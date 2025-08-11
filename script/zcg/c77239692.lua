--纹章兽耶和华(ZCG)
function c77239692.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),4,3)
	c:EnableReviveLimit()

	--triple tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77239692,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCondition(c77239692.ttcon)
	e1:SetOperation(c77239692.ttop)
	e1:SetValue(SUMMON_TYPE_TRIBUTE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e2)
	
	--LV
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetValue(10)
	c:RegisterEffect(e3)
	
	--指示物
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(c77239692.thcon)
	e4:SetOperation(c77239692.thop)
	c:RegisterEffect(e4)
	--battle
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--[[local e7=Effect.CreateEffect(c)
	e7:SetCode(EVENT_BE_BATTLE_TARGET)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c77239692.condition)
	e7:SetOperation(c77239692.activate)
	c:RegisterEffect(e7)]]
	
	--DAMAGE
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_DAMAGE)
	e8:SetDescription(aux.Stringid(77239692,0))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCost(c77239692.cost)
	e8:SetTarget(c77239692.tg)
	e8:SetOperation(c77239692.op)
	c:RegisterEffect(e8)
end
----------------------------------------------------------------------------
function c77239692.ttfilter(c)
	return c:GetOriginalCode()==77239692 and c:IsReleasable()
end
function c77239692.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc<=3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c77239692.ttfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c77239692.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c77239692.ttfilter,tp,LOCATION_MZONE,0,1,1,nil)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
----------------------------------------------------------------------------
function c77239692.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsFaceup()
end
function c77239692.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	bc:AddCounter(0xa11,1)
	--double
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetCondition(c77239692.damcon)
	e1:SetOperation(c77239692.damop)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL) 
	bc:RegisterEffect(e2)   
end
function c77239692.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil
end
function c77239692.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,0)
end
--[[function c77239692.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c77239692.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	tc:AddCounter(0xa11,1) 
end]]
----------------------------------------------------------------------------
function c77239692.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77239692.filter(c)
	return c:IsFaceup() and c:GetCounter(0xa11)>0
end
function c77239692.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c77239692.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c77239692.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,g,1,0,0)
end
function c77239692.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Damage(1-tp,tc:GetCounter(0xa11)*1000,REASON_EFFECT)   
	end
end
