--武藤游戏-光
function c77240134.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77240134.spcon)
    c:RegisterEffect(e1)
	
    --disable effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetOperation(c77240134.disop2)
    c:RegisterEffect(e2)
    --disable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DISABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0xa,0xa)
    e3:SetTarget(c77240134.distg2)
    c:RegisterEffect(e3)
    --self destroy
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_SELF_DESTROY)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0xa,0xa)
    e4:SetTarget(c77240134.distg2)
    c:RegisterEffect(e4)	
	
    --direct attack
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e5)

    --remove
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(52687916,0))
    e6:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    --e6:SetCondition(c77240134.remcon)
    e6:SetTarget(c77240134.remtg)
    e6:SetOperation(c77240134.remop)
    c:RegisterEffect(e6)
end
-------------------------------------------------------------------------
function c77240134.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
------------------------------------------------------------------------
function c77240134.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77240134.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:GetCardTarget():IsContains(e:GetHandler())
end
------------------------------------------------------------------------
--[[function c77240134.remcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end]]
function c77240134.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,0x1e,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0x1e)
end
function c77240134.remop(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
    local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
    local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
    local sg=Group.CreateGroup()
    if g1:GetCount()>0 and ((g2:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(52687916,1))) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg1=g1:Select(tp,1,1,nil)
        Duel.HintSelection(sg1)
        sg:Merge(sg1)
    end
    if g2:GetCount()>0 and ((sg:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(52687916,2))) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg2=g2:Select(tp,1,1,nil)
        Duel.HintSelection(sg2)
        sg:Merge(sg2)
    end
    if g3:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(52687916,3))) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg3=g3:Select(tp,1,1,nil)
        sg:Merge(sg3)
    end
    local ct=Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	if ct>0 then
        Duel.Damage(1-tp,ct*1000,REASON_EFFECT)	
	end
end

