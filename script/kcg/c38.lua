-- Numeron Network
local s,id=GetID()
function s.initial_effect(c)
	-- Activate
	local e0 = Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(41418852,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1)
	e2:SetCondition(s.NNcondition)
    e2:SetCost(s.cpcost)
	e2:SetTarget(s.cptg)
	e2:SetOperation(s.cpop)
	c:RegisterEffect(e2)
	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(s.con)
	e4:SetOperation(s.op)
	c:RegisterEffect(e4)
end
s.listed_series={0x48,0x901,0x177,0x1178}

function s.cfilter(c)
	return c:GetFlagEffect(id)==0
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_EXTRA,0,1,nil)
end
function s.scon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	return c:IsOnField() and c:IsFaceup() and not c:IsDisabled()
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_EXTRA,0,nil)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		local e01=Effect.CreateEffect(c)
		e01:SetType(EFFECT_TYPE_FIELD)
		e01:SetCode(EFFECT_XYZ_MATERIAL)
		e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e01:SetRange(LOCATION_EXTRA)
		e01:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e01:SetCondition(s.scon)
		e01:SetValue(function(e,ec,rc,tp) return rc==tc end)
		e01:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e01)
		local e02=e01:Clone()
		e02:SetCode(EFFECT_XYZ_LEVEL)
		e02:SetTarget(s.xyztg)
		e02:SetValue(function(e,mc,rc) return rc==tc and 4,mc:GetLevel() or mc:GetLevel() end)
		tc:RegisterEffect(e02)
		local e03=e02:Clone()
		e03:SetCode(EFFECT_XYZ_LEVEL)
		e03:SetTarget(s.xyztg)
		e03:SetValue(function(e,mc,rc) return rc==tc and 8,mc:GetLevel() or mc:GetLevel() end)
		tc:RegisterEffect(e03)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_SPSUMMON_SUCCESS)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e4:SetCondition(s.scon)
		e4:SetOperation(s.op2)
		tc:RegisterEffect(e4)
	end
end
function s.xyztg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	if e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_CONTROL)
		e1:SetValue(1-tp)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e:GetHandler():RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetDescription(aux.Stringid(id,1))
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetValue(1)
		e:GetHandler():RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(3312)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT|RESETS_STANDARD)
		e:GetHandler():RegisterEffect(e3)
		local e5=e3:Clone()
		e5:SetDescription(3310)
		e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e:GetHandler():RegisterEffect(e5)
		local e6=e5:Clone()
		e6:SetDescription(3309)
		e6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e:GetHandler():RegisterEffect(e6)
	end
	e:Reset()
end

function s.NNcondition(e, tp, eg, ep, ev, re, r, rp)
	return (Duel.GetMatchingGroupCount(nil, tp, LOCATION_MZONE + LOCATION_SZONE, 0, e:GetHandler()) == 0 and
			   Duel.GetTurnPlayer() == 1 - tp) or Duel.GetTurnPlayer() == tp
end
function s.NRTfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsSetCard(0x901) or c:IsSetCard(0x177) or c:IsSetCard(0x1178)) and c:IsAbleToGraveAsCost()
	and c:CheckActivateEffect(false,true,false)~=nil
end
function s.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk == 0 then
        return e:GetHandler():GetFlagEffect(id) < 1 + e:GetHandler():GetFlagEffect(602)
    end
    e:GetHandler():RegisterFlagEffect(id, RESET_EVENT + 0x1fe0000 + RESET_PHASE + PHASE_END, 0, 1)
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.NRTfilter2,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.NRTfilter2,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
    Duel.ClearOperationInfo(0)
    e:SetCategory(te:GetCategory())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end

function s.cnofilters(c)
	local no=c.xyz_number
	return (no and no>=101 and no<=107 and c:IsSetCard(0x48))
	or c:IsCode(787,67926903)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(s.cnofilters,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED) and chkc:IsControler(tp) and s.cnofilters(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.cnofilters,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(s.cxfilters, tp, LOCATION_MZONE, 0, 1, nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,s.cnofilters,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil)
end
function s.cxfilters(c)
	return c:IsCode(787, 67926903) and c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local a = Duel.SelectMatchingCard(tp, s.cxfilters, tp, LOCATION_MZONE, 0, 1, 1, nil):GetFirst()
		if a then Duel.Overlay(a,tc) end
	end
end