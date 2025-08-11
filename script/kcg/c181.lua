--神海部(KDIY)
local s,id=GetID()
function s.initial_effect(c)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(s.sdcon)
	c:RegisterEffect(e1)

	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
s.listed_series={0x3013,0x557}

function s.sdcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0x3013),0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

function s.filter(c)
	return c:IsSetCard(0x557) and c:IsMonster()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil)
	g:Remove(s.codefilterchk,nil,e:GetHandler())
	if c:IsFacedown() or #g<=0 then return end
	repeat
		local tc=g:GetFirst()
		local code=tc:GetOriginalCode()
		local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
		c:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,0,0)
		local e0=Effect.CreateEffect(c)
		e0:SetCode(id)
		e0:SetLabel(code)
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
		g:Remove(s.codefilter,nil,code)
	until #g<=0
end
function s.codefilter(c,code)
	return c:IsOriginalCode(code) and c:IsSetCard(0x557)
end
function s.codefilterchk(c,sc)
	return sc:GetFlagEffect(c:GetOriginalCode())>0
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil)
	if not g:IsExists(s.codefilter,1,nil,e:GetLabelObject():GetLabel()) or c:IsDisabled() then
		c:ResetEffect(e:GetLabel(),RESET_COPY)
		c:ResetFlagEffect(e:GetLabelObject():GetLabel())
	end
end