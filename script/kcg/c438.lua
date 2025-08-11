--ZS-雙頭龍賢者 (K)
local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33725002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)	

	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(45082499,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetRange(LOCATION_MZONE)
    e2:SetLabelObject(e1)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)

   	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(31764700,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(s.rdcon)
	e3:SetOperation(s.rdop)
	c:RegisterEffect(e3)
end
s.listed_series={0x7f, 0x48}

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x48) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
        Duel.SpecialSummonComplete()
        e:SetLabelObject(tc)
	end
end

function s.filter(c,tc)
	return c:IsFaceup() and c==tc
end
function s.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x7f)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
      local tc=e:GetLabelObject():GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc==tc end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tc)
            and Duel.IsExistingTarget(s.filter2,tp,LOCATION_MZONE,0,1,tc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter2,tp,LOCATION_MZONE,0,1,1,tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tc)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
      if g:GetCount()<=1 then return end
      local tc2=g:GetFirst()
	local tc1=g:GetNext()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=1 
            or tc1:IsFacedown() or not tc1:IsRelateToEffect(e) 
            or tc2:IsFacedown() or not tc2:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
        Duel.SendtoGrave(tc1,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,tc1,tc2,true)
	Duel.Equip(tp,c,tc2,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(s.eqlimit)
      e1:SetLabelObject(tc2)
	c:RegisterEffect(e1)
	local e12=Effect.CreateEffect(tc1)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_EQUIP_LIMIT)
	e12:SetReset(RESET_EVENT+0x1fe0000)
	e12:SetValue(s.eqlimit)
      e12:SetLabelObject(tc2)
	tc1:RegisterEffect(e12)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(s.atkval)
      e2:SetLabelObject(tc1)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function s.atkval(e,c)
      local tc=e:GetHandler():GetEquipTarget()
      if tc:GetEquipGroup():IsContains(e:GetLabelObject()) then
	return e:GetLabelObject():GetAttack()+e:GetOwner():GetAttack() end
      if not tc:GetEquipGroup():IsContains(e:GetLabelObject()) then
	return e:GetOwner():GetAttack() end
end

function s.rdcon(e,tp,eg,ep,ev,re,r,rp)
      if Duel.GetAttacker()~=nil then return e:GetHandler():GetEquipTarget() and Duel.GetAttacker()==e:GetHandler():GetEquipTarget() and not e:GetHandler():IsStatus(STATUS_CHAINING) end
end
function s.rdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
      local atk=c:GetEquipTarget():GetAttack()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(atk)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)     
end

