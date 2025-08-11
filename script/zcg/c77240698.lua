--地缚神 阿喀维诺(ZCG)
local s,id=GetID()
function s.initial_effect(c)
		--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e0:SetCondition(s.spcon)
	c:RegisterEffect(e0)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	s.SetCountLimit(e1)
	e1:SetCost(s.cost)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e99=Effect.CreateEffect(c)
	e99:SetDescription(aux.Stringid(id,1))
	e99:SetCategory(CATEGORY_TODECK)
	e99:SetType(EFFECT_TYPE_IGNITION)
	e99:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e99:SetRange(LOCATION_MZONE)
	s.SetCountLimit(e99)
	e99:SetTarget(s.tg)
	e99:SetOperation(s.op)
	c:RegisterEffect(e99)
   --handes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	s.SetCountLimit(e2)
	e2:SetCondition(s.condition2)
	e2:SetCost(s.cost2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	s.SetCountLimit(e3)
	e3:SetOperation(s.operation9)
	c:RegisterEffect(e3)
end
function s.operation9(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
function s.SetCountLimit(e)
   if e==nil then return end
   if aux.IsKCGScript then
	  e:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
   else
	  e:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	end
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and eg:GetFirst():GetControler()==1-tp
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local res=Group.CreateGroup()
	while tc do
		if tc:IsOnField() then
			res:AddCard(tc)
		 end
		tc=eg:GetNext() 
	end
	Duel.Destroy(res,REASON_EFFECT)
end
function s.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToDeck()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
end
function s.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemoveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local gg=Duel.GetOperatedGroup()
	gg:KeepAlive()
	e:SetLabelObject(gg)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject():GetFirst()
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetValue(tc:GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(tc:GetDefense())
		c:RegisterEffect(e2)
	end
end