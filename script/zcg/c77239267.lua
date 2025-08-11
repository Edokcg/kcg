--奥利哈刚的遗迹 亚特兰提斯2(ZCG)
function c77239267.initial_effect(c)
    c:EnableCounterPermit(0xa11)
    --发动效果
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN) 
    e1:SetTarget(c77239267.addtg)
    e1:SetOperation(c77239267.addop)
    e1:SetLabel(1)	
    c:RegisterEffect(e1)

    --效果免疫
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetValue(c77239267.efilter)
    c:RegisterEffect(e2)
	
    --放置指示物
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_COUNTER)
    e3:SetType(EFFECT_TYPE_QUICK_F)
    e3:SetCode(EVENT_CHAINING)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCondition(c77239267.con)
    e3:SetTarget(c77239267.tg)
    e3:SetOperation(c77239267.op)
    c:RegisterEffect(e3)

    --检索
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77239267,0))
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e4:SetCost(c77239267.cost)
    e4:SetTarget(c77239267.tg1)
    e4:SetOperation(c77239267.op1)
    c:RegisterEffect(e4)

    --破坏
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(77239267,1))
    e5:SetCategory(CATEGORY_DESTROY+CATEGORY_HANDES)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_FZONE)
    e5:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e5:SetCost(c77239267.cost2)
    e5:SetTarget(c77239267.tg2)
    e5:SetOperation(c77239267.op2)
    c:RegisterEffect(e5)

    --卡组破坏
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(77239267,2))			
    e6:SetType(EFFECT_TYPE_IGNITION)	
    e6:SetRange(LOCATION_FZONE)	
    e6:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE) 		
    e6:SetCost(c77239267.cost3)	
    e6:SetOperation(c77239267.op3)
    c:RegisterEffect(e6)	
end
---------------------------------------------------------------------------------
function c77239267.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetLabel(),0,0xa11)
end
function c77239267.addop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0xa11,e:GetLabel())
    end
end
---------------------------------------------------------------------------------
function c77239267.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
---------------------------------------------------------------------------------
function c77239267.con(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandler():GetCode()~=77239267
end
function c77239267.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xa11)
end
function c77239267.op(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0xa11,1)
    end
end
---------------------------------------------------------------------------------
function c77239267.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xa11,1,REASON_COST) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.RemoveCounter(tp,1,0,0xa11,1,REASON_COST)
end
function c77239267.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239267.op1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    Duel.SendtoHand(g,nil,REASON_EFFECT)
end
---------------------------------------------------------------------------------
function c77239267.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xa11,2,REASON_COST) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.RemoveCounter(tp,1,0,0xa11,2,REASON_COST)
end
function c77239267.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	or Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)	
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)	
end
function c77239267.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local b1=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil)
	if not (b1 or b2) then return end
	    local ops={}
	    local opval={}
	    local off=1
	    if b1 then
		ops[off]=aux.Stringid(77239267,3)
		opval[off-1]=1
		off=off+1
	    end
	    if b2 then
		ops[off]=aux.Stringid(77239267,4)
		opval[off-1]=2
		off=off+1
	    end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	    if opval[op]==1 then
		    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
            Duel.Destroy(sg,REASON_EFFECT)
		else
		    local g=Duel.GetFieldGroup(e:GetOwnerPlayer(),0,LOCATION_HAND)
            Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
---------------------------------------------------------------------------------
function c77239267.costfilter(c)
    return c:IsAbleToGrave()
end
function c77239267.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xa11,3,REASON_COST) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.RemoveCounter(tp,1,0,0xa11,3,REASON_COST)
end
function c77239267.op3(e,tp,eg,ep,ev,re,r,rp)
    local g2=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
    --if g2==0 or g2%2~=0 then Duel.Destroy(e:GetHandler(),REASON_RULE) return end 
    local gc=Duel.GetMatchingGroup(c77239267.costfilter,1-tp,LOCATION_DECK,0,nil):RandomSelect(1-tp,math.floor(g2/2))
    Duel.SendtoGrave(gc,REASON_COST)
end
---------------------------------------------------------------------------------

