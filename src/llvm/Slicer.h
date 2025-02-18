#ifndef _LLVM_DG_SLICER_H_
#define _LLVM_DG_SLICER_H_

// ignore unused parameters in LLVM libraries
#if (__clang__)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-parameter"
#else
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
#endif

#include <llvm/Config/llvm-config.h>
#if ((LLVM_VERSION_MAJOR == 3) && (LLVM_VERSION_MINOR < 5))
 #include <llvm/Support/CFG.h>
#else
 #include <llvm/IR/CFG.h>
#endif

#include <llvm/IR/Constants.h>
#include <llvm/IR/Value.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/GlobalVariable.h>
#include <llvm/IR/Instructions.h>
#include <llvm/Support/raw_ostream.h>

#include <llvm/IR/ValueHandle.h>
#include <llvm/Transforms/Utils/ValueMapper.h>

#if (__clang__)
#pragma clang diagnostic pop // ignore -Wunused-parameter
#else
#pragma GCC diagnostic pop
#endif

#include "analysis/Slicing.h"
#include "LLVMDependenceGraph.h"
#include "LLVMNode.h"


namespace dg {

class LLVMNode;

template <typename Val>
static void dropAllUses(Val *V)
{
    for (auto I = V->use_begin(), E = V->use_end(); I != E; ++I) {
#if ((LLVM_VERSION_MAJOR == 3) && (LLVM_VERSION_MINOR < 5))
        llvm::Value *use = *I;
#else
        llvm::Value *use = I->getUser();
#endif

       // drop the reference to this value
       llvm::cast<llvm::Instruction>(use)->replaceUsesOfWith(V, nullptr);
   }
}


class LLVMSlicer : public analysis::Slicer<LLVMNode>
{
public:
    LLVMSlicer(){}

    void setCloner(Cloner *cloner) {
        this->cloner = cloner;
    }

    void keepFunctionUntouched(const char *n)
    {
        dont_touch.insert(n);
    }

    /* virtual */
    bool removeNode(LLVMNode *node)
    {
        using namespace llvm;

        //Value *val = node->getKey();
        Value *val = getClonedValue(node->getKey(), currentSliceId);
        // if there are any other uses of this value,
        // just replace them with undef
        val->replaceAllUsesWith(UndefValue::get(val->getType()));

        Instruction *Inst = dyn_cast<Instruction>(val);
        if (Inst) {
            Inst->eraseFromParent();
        } else {
            GlobalVariable *GV = dyn_cast<GlobalVariable>(val);
            if (GV)
                GV->eraseFromParent();
        }

        return true;
    }

    /* virtual */
    void removeBlock(LLVMBBlock *block)
    {
        assert(block);

        llvm::Value *val = block->getKey();
        if (val == nullptr)
            return;

        //llvm::BasicBlock *blk = llvm::cast<llvm::BasicBlock>(val);
        llvm::BasicBlock *blk = getClonedBlock(llvm::cast<llvm::BasicBlock>(val), currentSliceId);
        for (auto& succ : block->successors()) {
            if (succ.label == 255)
                continue;

            // don't adjust phi nodes in this block if this is a self-loop,
            // we're gonna remove the block anyway
            if (succ.target == block)
                continue;

            llvm::Value *sval = succ.target->getKey();
            if (sval) {
                llvm::BasicBlock *sblock = getClonedBlock(llvm::cast<llvm::BasicBlock>(sval), currentSliceId);
                adjustPhiNodes(sblock, blk);
                //adjustPhiNodes(llvm::cast<llvm::BasicBlock>(sval), blk);
            }
        }

        // We need to drop the reference to this block in all
        // braching instructions that jump to this block.
        // See #99
        dropAllUses(blk);

        // we also must drop refrences to instructions that are in
        // this block (or we would need to delete the blocks in
        // post-dominator order), see #101
        for (llvm::Instruction& Inst : *blk)
            dropAllUses(&Inst);

        // finally, erase the block per se
        blk->eraseFromParent();
    }

    // override slice method
    uint32_t slice(LLVMNode *start, uint32_t sl_id = 0)
    {
        (void) sl_id;
        (void) start;

        assert(0 && "Do not use this method with LLVM dg");
        return 0;
    }

    uint32_t slice(LLVMDependenceGraph *,
                   LLVMNode *start, uint32_t sl_id = 0)
    {
        currentSliceId = sl_id;

        // mark nodes for slicing
        assert(start || sl_id != 0);
        if (start)
            sl_id = mark(start, sl_id);

        // take every subgraph and slice it intraprocedurally
        // this includes the main graph
        extern std::map<const llvm::Value *,
                        LLVMDependenceGraph *> constructedFunctions;
        for (auto& it : constructedFunctions) {
            if (dontTouch(it.first->getName()))
                continue;

            LLVMDependenceGraph *subdg = it.second;
            sliceGraph(subdg, sl_id);
        }

        return sl_id;
    }

private:
        /*
    void sliceCallNode(LLVMNode *callNode,
                       LLVMDependenceGraph *graph, uint32_t slice_id)
    {
        LLVMDGParameters *actualparams = callNode->getParameters();
        LLVMDGParameters *formalparams = graph->getParameters();

        if (!actualparams) {
            assert(!formalparams && "Have only one of params");
            return; // no params - nothing to do
        }

        assert(formalparams && "Have only one of params");
        assert(formalparams->size() == actualparams->size());

        // FIXME slice arguments away
    }

    void sliceCallNode(LLVMNode *callNode, uint32_t slice_id)
    {
        for (LLVMDependenceGraph *subgraph : callNode->getSubgraphs())
            sliceCallNode(callNode, subgraph, slice_id);
    }
        */
    
    llvm::Value *getClonedValue(llvm::Function *f, llvm::Value *value, uint32_t sliceId) {
        using namespace llvm;
        Cloner::SliceInfo *si = cloner->getSliceInfo(f, sliceId);
        if (!si) {
            return value;
        }

        ValueToValueMapTy &vmap = *(si->v2vmap);
        if (vmap.find(value) == vmap.end()) {
            return value;
        }

        WeakVH &wvh = vmap[value];
        return &*wvh;
    }

    llvm::Function *getClonedFunction(llvm::Function *f, uint32_t sliceId) {
        using namespace llvm;
        Cloner::SliceInfo *si = cloner->getSliceInfo(f, sliceId);
        if (!si) {
            return f;
        }
        return si->f;
    }

    llvm::Value *getClonedValue(llvm::Value *value, uint32_t sliceId) {
        using namespace llvm;
        Instruction *inst = dyn_cast<Instruction>(value);
        if (inst) {
            return getClonedValue(inst->getParent()->getParent(), value, sliceId);
        }

        BasicBlock *block = dyn_cast<BasicBlock>(value);
        if (block) {
            return getClonedValue(block->getParent(), value, sliceId);
        }

        Function *f = dyn_cast<Function>(value);
        if (f) {
            return getClonedFunction(f, sliceId);
        }

        assert(false);
    }

    llvm::BasicBlock *getClonedBlock(llvm::BasicBlock *block, uint32_t sliceId) {
        using namespace llvm;
        Value *v = getClonedValue(block, sliceId);
        return cast<BasicBlock>(v);
    }

    static void
    adjustPhiNodes(llvm::BasicBlock *pred, llvm::BasicBlock *blk)
    {
        using namespace llvm;

        for(Instruction& I : *pred) {
            PHINode *phi = dyn_cast<PHINode>(&I);
            if (phi) {
                // don't try remove block that we already removed
                int idx = phi->getBasicBlockIndex(blk);
                if (idx < 0)
                    continue;

                // the second argument is DeletePHIIFEmpty.
                // We don't want that, since that would make
                // dependence graph inconsistent. We'll
                // slice it away later, if it's empty
                phi->removeIncomingValue(idx, false);
            } else {
                // phi nodes are always at the beginning of the block
                // so if this is the first value that is not PHI,
                // there won't be any other and we can bail out
                break;
            }
        }
    }

    static inline bool shouldSliceInst(const llvm::Value *val)
    {
        using namespace llvm;
        const Instruction *Inst = dyn_cast<Instruction>(val);
        if (!Inst)
            return true;

        switch (Inst->getOpcode()) {
            case Instruction::Unreachable:
#if 0
            case Instruction::Br:
            case Instruction::Switch:
            case Instruction::Ret:
#endif
                return false;
            default:
                return true;
        }
    }

    LLVMBBlock *
    createNewExitBB(LLVMDependenceGraph *graph)
    {
        using namespace llvm;

        LLVMBBlock *exitBB = new LLVMBBlock();

        Module *M = graph->getModule();
        LLVMContext& Ctx = M->getContext();
        BasicBlock *block = BasicBlock::Create(Ctx, "safe_return");

        Value *fval = graph->getEntry()->getKey();
        //Function *F = cast<Function>(fval);
        Function *F = getClonedFunction(cast<Function>(fval), currentSliceId);
        F->getBasicBlockList().push_back(block);

        // fill in basic block just with return value
        ReturnInst *RI;
        if (F->getReturnType()->isVoidTy())
            RI = ReturnInst::Create(Ctx, block);
        else if (F->getName().equals("main"))
            // if this is main, than the safe exit equals to returning 0
            // (it is just for convenience, we wouldn't need to do this)
            RI = ReturnInst::Create(Ctx,
                                    ConstantInt::get(Type::getInt32Ty(Ctx), 0),
                                    block);
        else
            RI = ReturnInst::Create(Ctx,
                                    UndefValue::get(F->getReturnType()),
                                    block);

        LLVMNode *newRet = new LLVMNode(RI);
        graph->addNode(newRet);

        exitBB->append(newRet);
        exitBB->setKey(block);
        exitBB->setDG(graph);

        return exitBB;
    }

    LLVMBBlock* addNewExitBB(LLVMDependenceGraph *graph)
    {
        // FIXME: don't create new one, create it
        // when creating graph and just use that one
        LLVMBBlock *newExitBB = createNewExitBB(graph);
        graph->setExitBB(newExitBB);
        graph->setExit(newExitBB->getLastNode());
        // do not add the block to the graph,
        // we'll do it at the end of adjustBBlocksSucessors,
        // because this function is called while iterating
        // over blocks, so that we won't corrupt the iterator

        return newExitBB;
    }

    // when we sliced away a branch of CFG, we need to reconnect it
    // to exit block, since on this path we would silently terminate
    // (this path won't have any effect on the property anymore)
    void adjustBBlocksSucessors(LLVMDependenceGraph *graph, uint32_t slice_id)
    {
        LLVMBBlock *oldExitBB = graph->getExitBB();
        assert(oldExitBB && "Don't have exit BB");

        LLVMBBlock *newExitBB = nullptr;

        for (auto& it : graph->getBlocks()) {
            //const llvm::BasicBlock *llvmBB
            //    = llvm::cast<llvm::BasicBlock>(it.first);
            const llvm::BasicBlock *llvmBB
                = getClonedBlock(llvm::cast<llvm::BasicBlock>(it.first), currentSliceId);
            const llvm::TerminatorInst *tinst = llvmBB->getTerminator();
            LLVMBBlock *BB = it.second;

            // nothing to do
            if (BB->successorsNum() == 0)
                continue;

            // if the BB has two successors and one is self-loop and
            // the branch inst is going to be removed, then the brach
            // that created the self-loop has no meaning to the sliced
            // program and this is going to be an unconditional jump
            // to the other branch
            // NOTE: do this before the next action, to rename the label if needed
            if (BB->successorsNum() == 2
                && BB->getLastNode()->getSlice() != slice_id
                && !BB->successorsAreSame()) {

                bool found = BB->removeSuccessorsTarget(BB);
                // we have two different successors, none of them
                // is self-loop and we're slicing away the brach inst?
                // This should not happen...
                assert(found && "This should not happen...");
                assert(BB->successorsNum() == 1 && "Should have only one successor");

                // continue here to rename the only label if needed
            }

            // if the BB has only one successor and the terminator
            // instruction is going to be sliced away, it means that
            // this is going to be an unconditional jump,
            // so just make the label 0
            if (BB->successorsNum() == 1
                && BB->getLastNode()->getSlice() != slice_id) {
                auto edge = *(BB->successors().begin());

                // modify the edge
                edge.label = 0;
                if (edge.target == oldExitBB) {
                     if (!newExitBB)
                        newExitBB = addNewExitBB(graph);

                    edge.target = newExitBB;
                }

                // replace the only edge
                BB->removeSuccessors();
                BB->addSuccessor(edge);

                continue;
            }

            // when we have more successors, we need to fill in
            // jumps under labels that we sliced away

            DGContainer<uint8_t> labels;
            // go through BBs successors and gather all labels
            // from edges that go from this BB. Also if there's
            // a jump to return block, replace it with new
            // return block
            for (const auto& succ : BB->successors()) {
                // skip artificial return basic block.
                if (succ.label == 255 || succ.target == oldExitBB)
                    continue;

                labels.insert(succ.label);
            }

            // replace missing labels. Label should be from 0 to some max,
            // no gaps, so jump to safe exit under missing labels
            for (uint8_t i = 0; i < tinst->getNumSuccessors(); ++i) {
                if (!labels.contains(i)) {
                     if (!newExitBB)
                        newExitBB = addNewExitBB(graph);

                    bool ret = BB->addSuccessor(newExitBB, i);
                    assert(ret && "Already had this CFG edge, that is wrong");
                }
            }

            // this BB is going to be removed
            if (newExitBB)
                BB->removeSuccessorsTarget(oldExitBB);

            // if we have all successor edges pointing to the same
            // block, replace them with one successor (thus making
            // unconditional jump)
            if (BB->successorsNum() > 1 && BB->successorsAreSame()) {
                LLVMBBlock *succ = BB->successors().begin()->target;

                BB->removeSuccessors();
                BB->addSuccessor(succ, 0);
#ifdef ENABLE_DEBUG
                assert(BB->successorsNum() == 1
                       && "BUG: in removeSuccessors() or addSuccessor()");
#endif
            }

#ifdef ENABLE_DEBUG
            // check the BB
            std::set<int> labels;
            for (const auto& succ : BB->successors()) {
                assert(!newExitBB || succ.target != oldExitBB
                        && "A block has the old BB as successor");
                // we can have more labels with different targets,
                // but we can not have one target with more labels
                assert(labels.insert(succ.label).second
                        && "Already have a label");
            }

            // check that we have all labels without any gep
            auto l = labels.begin();
            for (int i = 0; i < labels.size(); ++i) {
                // set is ordered, so this must hold
                assert(i == *l++ && "Labels have a gap");
            }
#endif
        }

        if (newExitBB) {
            /* TODO: do we have to clone the key ??? */
            graph->addBlock(newExitBB->getKey(), newExitBB);
            assert(graph->getExitBB() == newExitBB);
            // NOTE: do not delete the old block
            // because it is the unified BB that is kept in
            // unique_ptr, so it will be deleted later automatically.
            // Deleting it would lead to double-free
        }
    }

    void sliceGraph(LLVMDependenceGraph *graph, uint32_t slice_id)
    {
        // first slice away bblocks that should go away
        sliceBBlocks(graph, slice_id);

        // make graph complete
        adjustBBlocksSucessors(graph, slice_id);

        // now slice away instructions from BBlocks that left
        for (auto I = graph->begin(), E = graph->end(); I != E;) {
            LLVMNode *n = I->second;
            // shift here, so that we won't corrupt the iterator
            // by deleteing the node
            ++I;

            // we added this node artificially and
            // we don't want to slice it away or
            // take any other action on it
            if (n == graph->getExit())
                continue;

            ++statistics.nodesTotal;

            // keep instructions like ret or unreachable
            // FIXME: if this is ret of some value, then
            // the value is undef now, so we should
            // replace it by void ref
            if (!shouldSliceInst(n->getKey()))
                continue;

            /*
            if (llvm::isa<llvm::CallInst>(n->getKey()))
                sliceCallNode(n, slice_id);
                */

            if (n->getSlice() != slice_id) {
                removeNode(n);
                graph->deleteNode(n);
                ++statistics.nodesRemoved;
            }
        }

        // create new CFG edges between blocks after slicing
        reconnectLLLVMBasicBlocks(graph);

        // if we sliced away entry block, our new entry block
        // may have predecessors, which is not allowed in the
        // LLVM
        ensureEntryBlock(graph);
    }

    bool dontTouch(const llvm::StringRef& r)
    {
        for (const char *n : dont_touch)
            if (r.equals(n))
                return true;

        return false;
    }

    void reconnectBBlock(LLVMBBlock *BB, llvm::BasicBlock *llvmBB)
    {
        using namespace llvm;

        TerminatorInst *tinst = llvmBB->getTerminator();
        assert((!tinst || BB->successorsNum() <= 2 || llvm::isa<llvm::SwitchInst>(tinst))
                && "BB has more than two successors (and it's not a switch)");

        if (!tinst) {
            // block has no terminator
            // It may occur for example if we have:
            //
            //   call error()
            //   br %exit
            //
            //  The br instruction has no meaning when error() abort,
            //  but if error is not marked as noreturn, then the br
            //  will be there and will get sliced, making the block
            //  unterminated. The same may happen if we remove unconditional
            //  branch inst

            LLVMContext& Ctx = llvmBB->getContext();
            Function *F = cast<Function>(llvmBB->getParent());
            bool create_return = true;

            if (BB->successorsNum() == 1) {
                const LLVMBBlock::BBlockEdge& edge = *(BB->successors().begin());
                if (edge.label != 255) {
                    // don't create return, we created branchinst
                    create_return = false;

                    //BasicBlock *succ = cast<BasicBlock>(edge.target->getKey());
                    BasicBlock *succ = getClonedBlock(cast<BasicBlock>(edge.target->getKey()), currentSliceId);
                    BranchInst::Create(succ, llvmBB);
                }
            }

            if (create_return) {
                assert(BB->successorsNum() == 0
                        && "Creating return to BBlock that has successors");

                if (F->getReturnType()->isVoidTy())
                    ReturnInst::Create(Ctx, llvmBB);
                else if (F->getName().equals("main"))
                    // if this is main, than the safe exit equals to returning 0
                    // (it is just for convenience, we wouldn't need to do this)
                    ReturnInst::Create(Ctx,
                                       ConstantInt::get(Type::getInt32Ty(Ctx), 0),
                                       llvmBB);
                else
                    ReturnInst::Create(Ctx,
                                       UndefValue::get(F->getReturnType()), llvmBB);

            }

            // and that is all we can do here
            return;
        }

        for (const LLVMBBlock::BBlockEdge& succ : BB->successors()) {
            // skip artificial return basic block
            if (succ.label == 255)
                continue;

            llvm::Value *val = succ.target->getKey();
            assert(val && "nullptr as BB's key");
            //llvm::BasicBlock *llvmSucc = llvm::cast<llvm::BasicBlock>(val);
            llvm::BasicBlock *llvmSucc = getClonedBlock(llvm::cast<llvm::BasicBlock>(val), currentSliceId);
            tinst->setSuccessor(succ.label, llvmSucc);
        }

        // if the block still does not have terminator
    }

    void reconnectLLLVMBasicBlocks(LLVMDependenceGraph *graph)
    {
        for (auto& it : graph->getBlocks()) {
            //llvm::BasicBlock *llvmBB
            //    = llvm::cast<llvm::BasicBlock>(it.first);
            llvm::BasicBlock *llvmBB
                = getClonedBlock(llvm::cast<llvm::BasicBlock>(it.first), currentSliceId);
            LLVMBBlock *BB = it.second;

            reconnectBBlock(BB, llvmBB);
        }
    }

    void ensureEntryBlock(LLVMDependenceGraph *graph)
    {
        using namespace llvm;

        //Value *val = graph->getEntry()->getKey();
        Value *val = getClonedValue(graph->getEntry()->getKey(), currentSliceId);
        Function *F = cast<Function>(val);

        // Function is empty, just bail out
        if(F->begin() == F->end())
            return;

        BasicBlock *entryBlock = &F->getEntryBlock();

        if (pred_begin(entryBlock) == pred_end(entryBlock)) {
            // entry block has no predecessor, we're ok
            return;
        }

        // it has some predecessor, create new one, that will just
        // jump on it
        LLVMContext& Ctx = graph->getModule()->getContext();
        BasicBlock *block = BasicBlock::Create(Ctx, "single_entry");

        // jump to the old entry block
        BranchInst::Create(entryBlock, block);

        // set it as a new entry by pusing the block to the front
        // of the list
        F->getBasicBlockList().push_front(block);

        // FIXME: propagate this change to dependence graph
    }

    // do not slice these functions at all
    std::set<const char *> dont_touch;
    Cloner *cloner;
    uint32_t currentSliceId;
};
} // namespace dg

#endif  // _LLVM_DG_SLICER_H_

