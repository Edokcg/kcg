local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER),5,4,s.ovfilter,aux.Stringid(id,0))
	aux.EnableCheckRankUp(c, nil, nil, 65676461)
	c:EnableReviveLimit()
	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(s.atcon)
	e1:SetOperation(s.atop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.damcon)
	e2:SetCost(s.damcost)
	e2:SetTarget(s.damtg)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2,false,EFFECT_MARKER_DETACH_XMAT)

	--Protect itself from destruction
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.reptg)
	e3:SetLabel(RESET_EVENT+RESETS_STANDARD)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_RANKUP_EFFECT)
	e4:SetLabelObject(e3)   
	c:RegisterEffect(e4)
end
s.xyz_number=32
s.listed_names={65676461, 49221191}
s.listed_series={0x48}
function s.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:GetRank() == 4 and c:IsAttribute(ATTRIBUTE_WATER)
end
function s.indes(e,c)
	return not c:IsSetCard(0x48)
end
function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and aux.bdocon(e,tp,eg,ep,ev,re,r,rp)
		and c:CanChainAttack()
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function s.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.ovfilter(c,tid)
	return  c:GetTurnID()==tid and bit.band(c:GetReason(),REASON_DESTROY)~=0 and c:IsType(TYPE_MONSTER)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ovfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,Duel.GetTurnCount()) end
	local g=Duel.GetMatchingGroup(s.ovfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,Duel.GetTurnCount())
	e:SetLabelObject(g)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	if g>0 then
	Duel.Overlay(c,g)
	end
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end