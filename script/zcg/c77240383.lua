--卡通艾亚托斯(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	 c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
		--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
 --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(s.sdescon)
	e3:SetOperation(s.sdesop)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(s.dircon)
	c:RegisterEffect(e4)
 --equip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetTarget(s.eqtg)
	e5:SetOperation(s.eqop)
	c:RegisterEffect(e5)
--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(s.sdescon2)
	e6:SetTarget(s.eqtg3)
	e6:SetOperation(s.sdesop2)
	c:RegisterEffect(e6)
end
function s.sfilter2(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsCode(55569674)
end
function s.filter9(c)
return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.eqtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter9,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_GRAVE)
end
function s.sdescon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.sfilter2,1,nil)
end
function s.sdesop2(e,tp,eg,ep,ev,re,r,rp)
	 local g=Duel.GetMatchingGroup(s.filter9,tp,0,LOCATION_GRAVE,nil)
	 if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
	local g2=Duel.GetOperatedGroup()
	local atk=g2:GetSum(Card.GetAttack)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk)
	e:GetHandler():RegisterEffect(e1)  
end
end
function s.filter(c,ec)
	return c:IsCode(55569674) and c:CheckEquipTarget(ec)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,c)
	if g:GetCount()>0 then
		Duel.Equip(tp,g:GetFirst(),c)
	end
end
function s.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function s.dircon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(s.cfilter2,tp,0,LOCATION_ONFIELD,1,nil)
end
function s.sfilter(c)
	return c:IsReason(REASON_DESTROY) and c:IsPreviousPosition(POS_FACEUP) and (c:GetPreviousCodeOnField()==15259703 or c:GetPreviousCodeOnField()==900000079 or c:GetPreviousCodeOnField()==511001251  ) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.sdescon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.sfilter,1,nil)
end
function s.sdesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function s.cfilter(c)
	return c:IsFaceup() and (c:IsCode(15259703) or c:IsCode(900000079) or c:IsCode(511001251))
end
function s.cfilter2(c)
	return c:IsSetCard(0x62)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()   
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil) or  Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_GRAVE,0,1,nil)
end






