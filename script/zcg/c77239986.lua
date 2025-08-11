--魔导战士 破坏女剑士
function c77239986.initial_effect(c)
    c:EnableCounterPermit(COUNTER_SPELL)
    c:SetCounterLimit(COUNTER_SPELL,3)
    --summon success
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239986,0))
    e1:SetCategory(CATEGORY_COUNTER)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c77239986.addct)
    e1:SetOperation(c77239986.addc)
    c:RegisterEffect(e1)
	
    --Atk
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetTarget(c77239986.tg)
    e2:SetValue(c77239986.attackup)
    c:RegisterEffect(e2)
	
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239986,1))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c77239986.descost)
    e3:SetTarget(c77239986.destg)
    e3:SetOperation(c77239986.desop)
    c:RegisterEffect(e3)
end
-----------------------------------------------------------------
function c77239986.addct(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,COUNTER_SPELL)
end
function c77239986.addc(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(COUNTER_SPELL,1)
    end
end
-----------------------------------------------------------------
function c77239986.tg(e,c)
    return c:IsCode(13002461) or c:IsCode(22923081) or c:IsCode(77239986) or c:IsCode(77239986)
end
function c77239986.attackup(e,c)
    return c:GetCounter(COUNTER_SPELL)*300
end
-----------------------------------------------------------------
function c77239986.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,COUNTER_SPELL,1,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,COUNTER_SPELL,1,REASON_COST)
end
function c77239986.filter(c)
    return c:IsFaceup() and c:IsLevelBelow(7)
end
--[[function c77239986.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239986.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    local sg=Duel.GetMatchingGroup(c77239986.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239986.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c77239986.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end]]

function c77239986.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c77239986.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c77239986.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77239986.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end