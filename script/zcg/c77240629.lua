--奥利哈刚 七武神·风之刃(ZCG)
local s,id=GetID()
function s.initial_effect(c)
		  c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(s.spcon)
	c:RegisterEffect(e0)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return d and d:IsControler(1-tp) end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if  c:IsFaceup() then
		local atk=Duel.GetAttackTarget():GetAttack()*2
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
		local g=Duel.GetMatchingGroup(Card.IsDefenseBelow,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil,c:GetAttack())
		if #g>0 then 
			Duel.Destroy(g,REASON_EFFECT)
			local gg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			Duel.ConfirmCards(tp,gg)
			local ct=Duel.SendtoDeck(gg,1-tp,2,REASON_EFFECT)
			Duel.Draw(1-tp,ct,REASON_EFFECT)
		end
	end
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL) and bc:GetAttack()>0
end
function s.spfilter(c)
	return c:IsSetCard(0xa50) and c:IsLevelAbove(5)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,7,nil)
end