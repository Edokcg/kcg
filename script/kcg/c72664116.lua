--Guardian Eatos
function c72664116.initial_effect(c)
--sum limit
local e1=Effect.CreateEffect(c)
e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_CANNOT_SUMMON)
e1:SetCondition(c72664116.sumlimit)
c:RegisterEffect(e1)
local e2=e1:Clone()
e2:SetCode(EFFECT_CANNOT_MSET)
c:RegisterEffect(e2)

--special summon
local e4=Effect.CreateEffect(c)
e4:SetType(EFFECT_TYPE_FIELD)
e4:SetCode(EFFECT_SPSUMMON_PROC)
e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
e4:SetRange(LOCATION_HAND)
e4:SetCondition(c72664116.spcon)
c:RegisterEffect(e4)
--remove
local e5=Effect.CreateEffect(c)
e5:SetDescription(aux.Stringid(1802450,1))
e5:SetCategory(CATEGORY_REMOVE)
e5:SetType(EFFECT_TYPE_IGNITION)
e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
e5:SetRange(LOCATION_MZONE)
e5:SetCost(c72664116.rmcost)
e5:SetTarget(c72664116.rmtg)
e5:SetOperation(c72664116.rmop)
c:RegisterEffect(e5)
end
function c72664116.cfilter(c)
	return c:IsFaceup() and c:IsCode(84419502)
end
function c72664116.sumlimit(e)
	return not Duel.IsExistingMatchingCard(c72664116.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end

function c72664116.spcon(e,c)
if c==nil then return true end
local tp=c:GetControler()
return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and not Duel.IsExistingMatchingCard(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end

function c72664116.costfilter(c)
	return c:IsCode(84419502) and c:IsAbleToGrave()
end
function c72664116.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return e:GetHandler():GetEquipGroup():IsExists(c72664116.costfilter,1,nil) end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
local g=e:GetHandler():GetEquipGroup():FilterSelect(tp,c72664116.costfilter,1,1,nil)
Duel.SendtoGrave(g,REASON_COST)
end
function c72664116.rmfilter(c)
return c:IsAbleToRemove()
end
function c72664116.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c72664116.rmfilter(chkc) end
if chk==0 then return Duel.IsExistingTarget(c72664116.rmfilter,tp,0,LOCATION_GRAVE,1,nil) end
Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,1)
end
function c72664116.rmop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local g=Duel.GetMatchingGroup(c72664116.rmfilter,tp,0,LOCATION_GRAVE,nil)
if g:GetCount()==0 then return end
local atk=0
local seq=0
local tc=g:GetFirst()
while tc do
local atk=atk + tc:GetTextAttack()
if tc:IsType(TYPE_MONSTER) and tc:GetAttack()>0 then	
Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
if tc:GetSequence()>seq then 
seq=tc:GetSequence()
end
tc=g:GetNext()
else return end
local e1=Effect.CreateEffect(e:GetHandler())
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_UPDATE_ATTACK)
e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
e1:SetValue(atk)
c:RegisterEffect(e1)
end
end
