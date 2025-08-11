--Ｎｏ．７６ 諧調光師グラディエール
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,nil,8,3,nil,nil,nil,nil,false,s.xyzcheck)

	--battle indestructable
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	--attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.attval)
	c:RegisterEffect(e1)
	
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(s.efindes)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.discon)
	e4:SetCost(s.discost)
	e4:SetTarget(s.distg)
	e4:SetOperation(s.disop)
	c:RegisterEffect(e4,false,EFFECT_MARKER_DETACH_XMAT)
end
s.xyz_number=76
s.listed_names={92015800}
s.listed_series={0x48}
function s.xyzcheck(g,tp,xyz)
	return g:GetClassCount(Card.GetAttribute)==#g
end
function s.indes(e,c)
	return not c:IsSetCard(0x48)
end

function s.attval(e,c)
	local att=0
	local og=e:GetHandler():GetOverlayGroup()
	for tc in aux.Next(og) do
		att=att|tc:GetAttribute()
	end
	return att
end
function s.efindes(e,te)
	local c=e:GetHandler()
	return c:IsAttribute(te:GetHandler():GetAttribute()) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function s.xyzol(c)
	return c:IsRace(RACE_FAIRY) and c:IsType(TYPE_XYZ)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and e:GetHandler():GetOverlayGroup():IsExists(s.xyzol,1,nil)
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) and c:IsType(TYPE_XYZ) then
		rc:CancelToGrave()
		Duel.Overlay(c,rc)
	end
end