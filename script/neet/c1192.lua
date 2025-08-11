--银河眼时空龙甲(neet)
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_DRAGON),1,1)
	c:EnableReviveLimit()   
	aux.AddUnionProcedure(c,s.unfilter)
	 --attack limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e6)

	--cannot link material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(2000)
	c:RegisterEffect(e1)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.rcon)
	e3:SetOperation(s.rop)
	c:RegisterEffect(e3)
end
function s.unfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_XYZ)
end
function s.filter(c)
	return c:IsMonster() and c:IsAbleToRemove() and c:IsRace(RACE_DRAGON)
end
function s.rcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil)
	return (r&REASON_COST)~=0 and re:IsActivated()
		and re:IsActiveType(TYPE_XYZ)
		and rc:GetEquipGroup():IsContains(c)
		and #g>0
		and ep==e:GetOwnerPlayer() and ev>=1
		and rc:GetOverlayCount()>=ev-1 and e:GetHandler():GetEquipTarget():IsSetCard(0x307b)
end
function s.rop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil)
	local tc=g:Select(tp,1,1)
	return Duel.Remove(tc,POS_FACEUP,REASON_COST)
end