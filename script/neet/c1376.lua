--超银河眼残光龙(neet)
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,8,3)
	c:EnableReviveLimit()
	--attack
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e0:SetValue(s.atkval)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.spcon)
	e1:SetCost(Cost.DetachFromSelf(1))
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1,false,EFFECT_MARKER_DETACH_XMAT)
end
s.listed_series={0x7b,0x55,0x48}
function s.atkval(e,c)
	return math.max(c:GetOverlayGroup():FilterCount(Card.IsSetCard,nil,0x55),c:GetOverlayGroup():FilterCount(Card.IsSetCard,nil,0x7b))--+1
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil) or e:GetHandler()==Duel.GetAttackTarget()
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x48) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_DEFENSE) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local bc0,bc1=Duel.GetBattleMonster(tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	local atk,def=tc:GetBaseAttack(),tc:GetBaseDefense()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_DEFENSE) and bc1 and bc1:IsFaceup() then
		if tc:IsFacedown() and tc:IsOnField() then Duel.ConfirmCards(1-tp,tc) end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		bc1:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-def)
		bc1:RegisterEffect(e2)
	end
end