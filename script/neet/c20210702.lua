-- Number 48: Shadow Lich (Manga)
local s, id = GetID()
function s.initial_effect(c)
	-- xyz summon
	Xyz.AddProcedure(c, aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK), 4, 3)
	c:EnableReviveLimit()
	-- battle indestructable
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(s.indes)
	c:RegisterEffect(e1)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_END_PHASE)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1,false,EFFECT_MARKER_DETACH_XMAT)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(s.uncon)
	e2:SetValue(s.unval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
end
s.xyz_number = 48
s.listed_series = {0x48}
s.listed_names = {16398080, 1426714}
function s.indes(e, c)
	return not c:IsSetCard(0x48)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,-2,500,1,RACE_FIEND,ATTRIBUTE_DARK) end
	local ft=1
	if e:GetHandler():GetOverlayGroup():IsExists(s.xyzol,1,nil) then ft=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft,tp,0)
end
function s.xyzol(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_XYZ)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,-2,500,1,RACE_FIEND,ATTRIBUTE_DARK) then
		local token=Group.FromCards(Duel.CreateToken(tp,id+1))
		if e:GetHandler():GetOverlayGroup():IsExists(s.xyzol,1,nil) then
		g:AddCard(Duel.CreateToken(tp,id+1)) end
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		local g,atk=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetMaxGroup(Card.GetAttack)
		if not g then atk=0 end
		--Set the Token's ATK
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
function s.uncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,id+1)
end
function s.unval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end