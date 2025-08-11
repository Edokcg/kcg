--エクゾディア·ネクロス
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

    local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(s.op)
	c:RegisterEffect(e4)

	-- --cannot destroy
	-- local e1=Effect.CreateEffect(c)
	-- e1:SetType(EFFECT_TYPE_SINGLE)
	-- e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	-- e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	-- e1:SetRange(LOCATION_MZONE)
	-- e1:SetCondition(s.batdescon)
	-- e1:SetValue(1)
	-- c:RegisterEffect(e1)

	-- local e2=Effect.CreateEffect(c)
	-- e2:SetType(EFFECT_TYPE_SINGLE)
	-- e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	-- e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	-- e2:SetRange(LOCATION_MZONE)
	-- e2:SetCondition(s.descon1)
	-- e2:SetValue(s.efdes1)
	-- c:RegisterEffect(e2)
	-- local e21=e2:Clone()
	-- e21:SetCondition(s.descon2)
	-- e21:SetValue(s.efdes2)
	-- c:RegisterEffect(e21)  
	-- local e22=e2:Clone()
	-- e22:SetCondition(s.descon3)
	-- e22:SetValue(s.efdes3)
	-- c:RegisterEffect(e22) 
	-- local e23=Effect.CreateEffect(c)
	-- e23:SetCategory(CATEGORY_ATKCHANGE)
	-- e23:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	-- e23:SetCode(EVENT_BATTLED)
	-- e23:SetRange(LOCATION_MZONE)
	-- e23:SetCondition(s.descon4)
	-- e23:SetOperation(s.operation)
	-- c:RegisterEffect(e23)
end
s.listed_names={405}
s.listed_series={0x40}

function s.codefilterchk(c,sc)
	return sc:GetFlagEffect(id+c:GetRealFieldID())>0
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x40)
	g:Remove(s.codefilterchk,nil,e:GetHandler())
	if c:IsFacedown() or #g<=0 then return end
	for tc in aux.Next(g) do
		local code=tc:GetOriginalCode()
		local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
		c:RegisterFlagEffect(id+tc:GetRealFieldID(),RESET_EVENT+RESETS_STANDARD,0,1)
		local e0=Effect.CreateEffect(c)
		e0:SetCode(id)
		e0:SetLabel(code)
		e0:SetLabelObject(tc)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e0,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetRange(LOCATION_MZONE)
		e1:SetLabel(cid)
		e1:SetLabelObject(e0)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetOperation(s.resetop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
	end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x40)
    local tc=e:GetLabelObject():GetLabelObject()
	if not g:IsContains(tc) then
		c:ResetEffect(e:GetLabel(),RESET_COPY)
		c:ResetFlagEffect(id+tc:GetRealFieldID())
		e:GetLabelObject():Reset()
		e:Reset()
	end
end

-- function s.batdesfilter(c)
-- 	return c:IsCode(33396948)
-- end
-- function s.batdescon(e,tp,eg,ep,ev,re,r,rp)
-- 	return Duel.IsExistingMatchingCard(s.batdesfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
-- end

-- function s.desfilter1(c)
-- 	return c:IsCode(44519536)
-- end
-- function s.descon1(e,tp,eg,ep,ev,re,r,rp)
-- 	return Duel.IsExistingMatchingCard(s.desfilter1,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
-- end
-- function s.efdes1(e,te)
-- 	return te:IsActiveType(TYPE_SPELL)
-- end
-- function s.desfilter2(c)
-- 	return c:IsCode(7902349)
-- end
-- function s.descon2(e,tp,eg,ep,ev,re,r,rp)
-- 	return Duel.IsExistingMatchingCard(s.desfilter2,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
-- end
-- function s.efdes2(e,te)
-- 	return te:IsActiveType(TYPE_MONSTER)
-- end
-- function s.desfilter3(c)
-- 	return c:IsCode(8124921)
-- end
-- function s.descon3(e,tp,eg,ep,ev,re,r,rp)
-- 	return Duel.IsExistingMatchingCard(s.desfilter3,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
-- end
-- function s.efdes3(e,te)
-- 	return te:IsActiveType(TYPE_TRAP)
-- end
-- function s.desfilter4(c)
-- 	return c:IsCode(70903634)
-- end
-- function s.descon4(e,tp,eg,ep,ev,re,r,rp)
-- 	  if Duel.GetAttacker()~=nil or Duel.GetAttackTarget()~=nil then
-- 	  return e:GetHandler()==Duel.GetAttacker() or e:GetHandler()==Duel.GetAttackTarget() end
-- end
-- function s.operation(e,tp,eg,ep,ev,re,r,rp)
-- 	local c=e:GetHandler()
-- 	if c:IsRelateToEffect(e) and c:IsFaceup() then
-- 		local e1=Effect.CreateEffect(c)
-- 		e1:SetType(EFFECT_TYPE_SINGLE)
-- 		e1:SetCode(EFFECT_UPDATE_ATTACK)
-- 		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
-- 		e1:SetValue(1000)
-- 		e1:SetReset(RESET_EVENT+0x1ff0000)
-- 		c:RegisterEffect(e1)
-- 	end
-- end

-- function s.splimit(e,se,sp,st)
-- 	return st==(SUMMON_TYPE_SPECIAL+332449)
-- end

-- function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
-- 	return tp==Duel.GetTurnPlayer()
-- end
-- function s.atkop(e,tp,eg,ep,ev,re,r,rp)
-- 	local c=e:GetHandler()
-- 	local e1=Effect.CreateEffect(c)
-- 	e1:SetType(EFFECT_TYPE_SINGLE)
-- 	e1:SetCode(EFFECT_UPDATE_ATTACK)
-- 	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
-- 	e1:SetReset(RESET_EVENT+0x1ff0000)
-- 	e1:SetValue(500)
-- 	c:RegisterEffect(e1)
-- end
-- function s.descon(e)
-- 	local p=e:GetHandlerPlayer()
-- 	return not Duel.IsExistingMatchingCard(Card.IsCode,p,LOCATION_GRAVE,0,1,nil,8124921)
-- 		or not Duel.IsExistingMatchingCard(Card.IsCode,p,LOCATION_GRAVE,0,1,nil,44519536)
-- 		or not Duel.IsExistingMatchingCard(Card.IsCode,p,LOCATION_GRAVE,0,1,nil,70903634)
-- 		or not Duel.IsExistingMatchingCard(Card.IsCode,p,LOCATION_GRAVE,0,1,nil,7902349)
-- 		or not Duel.IsExistingMatchingCard(Card.IsCode,p,LOCATION_GRAVE,0,1,nil,33396948)
-- end
