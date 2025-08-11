--奥利哈刚 凌空击碎 （ZCG）
function c77240265.initial_effect(c)
		--to hand  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(77240265,0))   
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_HAND)
	e3:SetTarget(c77240265.tftg)  
	e3:SetOperation(c77240265.tfop)  
	c:RegisterEffect(e3) 
 --cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e4)
--disable
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_DISABLE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetTargetRange(0,LOCATION_ONFIELD)
	e12:SetTarget(c77240265.distg9)
	c:RegisterEffect(e12)
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e7)
end
function c77240265.distg9(e,c)
	return c:IsSetCard(0xa50)
end
function c77240265.tftg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
	end
end
function c77240265.tfop(e,tp,eg,ep,ev,re,r,rp)  
	if  Duel.GetLocationCount(tp,LOCATION_MZONE)>0  then
	 Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_MZONE,POS_DEFENSE,true)
	end
end