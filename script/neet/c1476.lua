--异色眼水晶龙(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,2,3,s.matcheck)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.matcheck2)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.pencon)
	e1:SetTarget(s.pentg)
	e1:SetOperation(s.penop)
	c:RegisterEffect(e1)   
end
s.listed_series={0x98,0x99,0x9f}
s.listed_names={id}
function s.matfilter(c,lc,sumtype,tp)
	return c:IsType(TYPE_PENDULUM,lc,sumtype,tp)
end
function s.matcheck(g,lc,sumtype,tp)
	return g:IsExists(s.matfilter,2,nil,lc,sumtype,tp)
end
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.GetFieldCard(tp,LOCATION_PZONE,0) and not Duel.GetFieldCard(tp,LOCATION_PZONE,1)
end
function s.penfilter(c)
	return (c:IsSetCard(0x98) or c:IsSetCard(0x99) or c:IsSetCard(0x9f)) and c:IsType(TYPE_PENDULUM) and not c:IsCode(id) and not c:IsForbidden()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.penfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.penfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function s.matcheck2(e,c)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0x99) then
		--copy
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCost(s.cpcost)
		e1:SetOperation(s.cpop)
		c:RegisterEffect(e1)
		--cannot be target
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(function(e) return Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,0) or Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,1) end)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		c:RegisterEffect(e2)
		--indes
		local e3=e2:Clone()
		e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		c:RegisterEffect(e3)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e4)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	end
end
function s.cpfilter(c)
	return c:IsMonster() and c:IsSetCard(0x99) and not c:IsCode(id) and c:IsAbleToGraveAsCost()
end
function s.cpcost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cpfilter,tp,LOCATION_DECK|LOCATION_EXTRA,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cpfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetOriginalCode())
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		--Change name & copy effects
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	end
end