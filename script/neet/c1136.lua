--银河眼光子虹龙（neet）
local s,id=GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,nil,9,3,s.ovfilter,aux.Stringid(id,0))
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(s.actcon)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.cost)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
end
s.listed_series={0x107b}
s.listed_names={18963306}
function s.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsSetCard(0x107b,lc,SUMMON_TYPE_XYZ,tp) and c:IsType(TYPE_XYZ,lc,SUMMON_TYPE_XYZ,tp) and c:GetRank()==8
end
function s.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc2=g:GetFirst()
	while tc2 do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(math.ceil(tc2:GetBaseAttack()))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(math.ceil(tc2:GetBaseDefense()))
		tc2:RegisterEffect(e2)
		tc2=g:GetNext()
	end
end
