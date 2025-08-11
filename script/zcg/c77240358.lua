--不死之千年龙(ZCG)
local s,id=GetID()
function s.initial_effect(c)
  --avoid atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetCondition(s.atcon)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	   --token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1)
	e2:SetCondition(s.spcon1)
	e2:SetTarget(s.sptg1)
	e2:SetOperation(s.spop1)
	c:RegisterEffect(e2)  
 --atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.val)
	c:RegisterEffect(e3)  
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(s.filter,c:GetControler(),LOCATION_MZONE,0,nil)*500
end
function s.filter(c)
	return c:IsCode(77240359) or c:IsCode(77240352)
end
function s.cfilter2(c)
	return c:IsFaceup() and (c:IsCode(77240359) or c:IsCode(77240352))
end
function s.atcon(e)
	return Duel.IsExistingMatchingCard(s.cfilter2,e:GetOwnerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,77240359,0x1111,0x1111,1000,1000,1,RACE_ZOMBIE,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,77240359)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)	  
	end
end