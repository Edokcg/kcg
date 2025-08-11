--FNo.0 未来龍皇ホープ
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Xyz.AddProcedureX(c,s.xyzfilter,nil,3,aux.FaceupFilter(Card.IsCode,65305468),aux.Stringid(id,0),nil,nil,false,s.xyzcheck)
	--add setcode
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetValue(0x207f)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e3)
 	--damage val
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e6:SetValue(1)
	c:RegisterEffect(e6)   
	--Negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.discon)
	e4:SetCost(s.discost)
	e4:SetTarget(s.distg)
	e4:SetOperation(s.disop)
	c:RegisterEffect(e4)
end
s.listed_series={0x48}
s.xyz_number=0
s.listed_names={65305468}

function s.xyzfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_XYZ,xyz,sumtype,tp) and not c:IsSetCard(0x48)
end
function s.xyzcheck(g,tp,xyz)
	return g:GetClassCount(Card.GetRank)==1
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsOnField() and rc:IsRelateToEffect(re) and rc:IsAbleToChangeControler() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,1,0,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsOnField() and rc:IsRelateToEffect(re) and rc:IsAbleToChangeControler() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.GetControl(rc,tp)
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,e:GetHandler())
		if Duel.Destroy(g,REASON_EFFECT)>0 then
			local g2=Duel.GetOperatedGroup()
			local tc=g2:GetFirst()
			local dam=0
			while tc do
				local atk=tc:GetPreviousAttackOnField()
				if atk<0 then atk=0 end
				dam=dam+atk
				tc=g2:GetNext()
			end
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end
