--兰卡的落穴(neet)
local s,id=GetID()
function s.initial_effect(c)
	--特殊召唤时里侧表示除外
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.con)
	e1:SetTarget(s.target)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--Damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(s.con2)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op2)
	c:RegisterEffect(e1)
end
s.listed_series={0x108a}
s.listed_names={82738277}
function s.filter(c)
	return c:IsSetCard(0x108a) and c:IsType(TYPE_MONSTER)
end
function s.filter2(c,tp)
	return not c:IsSummonPlayer(tp) and c:IsSummonLocation(LOCATION_EXTRA) and c:IsAbleToRemove(tp,POS_FACEDOWN) and c:IsLocation(LOCATION_MZONE)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.filte  r2,nil,tp)
	local ct=#g
	if chk==0 then return ct==1 end
	Duel.SetTargetCard(eg)
	local tg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,tg,#tg,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.filter2,nil,tp):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	local tg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	local tc=tg:GetFirst()
	for tc in aux.Next(tg) do
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(g:GetFirst():GetBaseAttack())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	tc:RegisterEffect(e1,true)
		end
	end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and e:GetHandler():IsPreviousPosition(POS_FACEDOWN)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Damage(1-tp,800,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,82738277) and c:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
	Duel.SSet(tp,c)
	end
end