--双弓人马兽(ZCG)
local s,id=GetID()
function s.initial_effect(c)
--Activate
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetCode(EVENT_FREE_CHAIN)
c:RegisterEffect(e1)
--Destruction
local e2=Effect.CreateEffect(c)
e2:SetDescription(aux.Stringid(98710558,0))
e2:SetCategory(CATEGORY_DESTROY+CATEGORY_COIN+CATEGORY_DAMAGE)
e2:SetRange(LOCATION_SZONE)
e2:SetCountLimit(1)
e2:SetType(EFFECT_TYPE_IGNITION)
e2:SetCondition(s.condition)
e2:SetTarget(s.target)
e2:SetOperation(s.desop)
c:RegisterEffect(e2)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function s.filter(c)
return c:IsAbleToRemove() 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chkc then return false end
if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil) end
Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98710558,1))
local g1=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98710558,2))
local g2=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil) 
e:SetLabelObject(g1:GetFirst())
g1:Merge(g2)
Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
local tc1=e:GetLabelObject()
local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
local tc2=g:GetFirst()
if tc1==tc2 then tc2=g:GetNext() end
Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98710558,3))
local coin=Duel.SelectOption(tp,60,61)
local res=Duel.TossCoin(tp,1)
if coin~=res then
Duel.Destroy(tc2,REASON_EFFECT)
Duel.Damage(1-tp,tc2:GetAttack(),REASON_EFFECT)
else
Duel.Destroy(tc1,REASON_EFFECT)
Duel.Damage(tp,tc1:GetAttack(),REASON_EFFECT)
end
end