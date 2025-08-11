--违法的伪契约书 (KDIY)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(s.spcon2)
	e3:SetTarget(s.gtg)
	e3:SetOperation(s.gop)
	c:RegisterEffect(e3)
end
s.listed_series = {0x1903, 0x10ae}

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end

function s.filter1(c,mc,e,tp)
	local lv=c:GetLevel()
    if not c:HasLevel() and c:IsType(TYPE_XYZ) then lv=c:GetRank() end
	local clv=0
	if lv<=4 then
		clv=4
	elseif lv>=5 and lv<=6 then
		clv=6
	else
		clv=8
	end
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
	and Duel.IsExistingMatchingCard(s.filter12,tp,LOCATION_DECK,0,1,nil,mc,c,e,tp,clv)
end
function s.filter12(c,mc,oc,e,tp,lv)
	if not c:IsCode(511003050) or not c:IsCanBeSpecialSummoned(e,0,tp,true,false) then return false end
	mc:SetStatus(STATUS_NO_LEVEL,false)
	local e1=Effect.CreateEffect(mc)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetValue(TYPE_MONSTER)
	e1:SetCondition(function() return cetempchk end)
	mc:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(oc:GetRace())
	mc:RegisterEffect(e2,true)
	local e3=e2:Clone()
	c:RegisterEffect(e3,true)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e4:SetValue(oc:GetAttribute())
	mc:RegisterEffect(e4,true)
	local e5=e4:Clone()
	c:RegisterEffect(e5,true)
    local e6=e1:Clone()
    e6:SetCode(EFFECT_CHANGE_LEVEL)
    e6:SetValue(lv)
    mc:RegisterEffect(e6,true)
	local e7=e6:Clone()
	c:RegisterEffect(e7,true)
	local e8=e1:Clone()
	e8:SetCode(EFFECT_SET_ATTACK_FINAL)
	e8:SetValue(oc:GetAttack())
	mc:RegisterEffect(e8,true)
	local e9=e8:Clone()
	c:RegisterEffect(e9,true)
	local e10=e1:Clone()
	e10:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e10:SetValue(oc:GetDefense())
	mc:RegisterEffect(e10,true)
	local e11=e10:Clone()
	c:RegisterEffect(e11,true)
	local e12=Effect.CreateEffect(mc)
	e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_ADD_TYPE)
	e12:SetValue(TYPE_TUNER)
	c:RegisterEffect(e12,true)
	cetempchk=true
	local res=Duel.IsExistingMatchingCard(s.fufilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,mc) or Duel.IsExistingMatchingCard(s.syfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,mc,oc) or Duel.IsExistingMatchingCard(s.xzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,mc)
	cetempchk=false
	e1:Reset()
	e2:Reset()
	e3:Reset()
	e4:Reset()
	e5:Reset()
	e6:Reset()
	e7:Reset()
	e8:Reset()
	e9:Reset()
	e10:Reset()
	e11:Reset()
	e12:Reset()
	mc:SetStatus(STATUS_NO_LEVEL,true)
	return res and Duel.GetLocationCountFromEx(tp)>0
end
function s.fufilter(c,e,tp,tuners,nontuners)
	local g=Group.FromCards(tuners,nontuners)
	return c:IsSetCard(0x1903) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:IsType(TYPE_FUSION) and aux.SelectUnselectGroup(g,e,tp,2,2,s.rescon(c),0) and tuners:IsCanBeFusionMaterial(c) and nontuners:IsCanBeFusionMaterial(c)
end
function s.syfilter(c,e,tp,tuners,nontuners,oc)
	return c:IsSetCard(0x1903) and c:IsSetCard(0x1903) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) 
    and tuners:IsCanBeSynchroMaterial(c) and nontuners:IsCanBeSynchroMaterial(c) and not nontuners:IsType(TYPE_TUNER) 
    and tuners:HasLevel() and oc:HasLevel() and tuners:GetSynchroLevel(c)+oc:GetSynchroLevel(c)<13
end
function s.xzfilter(c,e,tp,tuners,nontuners)
	local g=Group.FromCards(tuners,nontuners)
	return c:IsSetCard(0x1903) and c:IsXyzSummonable(nil,g,2,2)
end
function s.filter2(c,e,tp,tuners,nontuners)
	local g=Group.FromCards(tuners,nontuners)
	return c:IsSetCard(0x1903) 
    and (c:IsXyzSummonable(nil,g,2,2) 
      or (c:IsSynchroSummonable(nil,g,2,2) and tuners:GetSynchroLevel(c)+nontuners:GetSynchroLevel(c)<13)
      or (c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and aux.SelectUnselectGroup(g,e,tp,2,2,s.rescon(c),0) and tuners:IsCanBeFusionMaterial(c) and nontuners:IsCanBeFusionMaterial(c)))
	and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end

function s.filter31(c,e,tp,sc)
	return c:IsFaceup() and (not e or not c:IsImmuneToEffect(e))
	and (not sc.synchro_parameters[0] or sc.synchro_parameters[0](c,sc,SUMMON_TYPE_SYNCHRO,tp))
end
function s.filter32(c,e,tp,sc)
	return c:IsFaceup() and (not e or not c:IsImmuneToEffect(e))
	and (not sc.synchro_parameters[3] or sc.synchro_parameters[3](c,sc,SUMMON_TYPE_SYNCHRO,tp))
end
function s.rescon(fc)
	return  function(sg,e,tp,mg)
				local t={}
				local res=fc:CheckFusionMaterial(sg,nil,sg)
				return res
			end
end
function s.gettype(c)
    local type=0
    if c:IsType(TYPE_XYZ) then
        type=type|TYPE_XYZ
    end
    if c:IsType(TYPE_FUSION) then
        type=type|TYPE_FUSION
    end
    if c:IsType(TYPE_SYNCHRO) then
        type=type|TYPE_SYNCHRO
    end
	return type
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc.IsFaceup() end
	local c=e:GetHandler()
    if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(s.filter1,tp,0,LOCATION_MZONE,1,nil,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter1,tp,0,LOCATION_MZONE,1,1,nil,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local oc=Duel.GetFirstTarget()
	if not oc or not oc:IsRelateToEffect(e) or oc:IsFacedown() then return end
    local lv=oc:GetLevel()
    local clv=0
    local clv2=0
    if lv<=4 then
        clv=4
    elseif lv>=5 and lv<=6 then
        clv=6
    else
        clv=8
    end
    local effchk=false
    if oc:HasLevel() then
        local e01=Effect.CreateEffect(c)
        e01:SetType(EFFECT_TYPE_SINGLE)
        e01:SetCode(EFFECT_CHANGE_LEVEL)
        e01:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e01:SetValue(clv)
        oc:RegisterEffect(e01)
        if oc:IsImmuneToEffect(e01) then effchk=true end
    end
    if oc:HasRank() then
        lv=oc:GetRank()
        if lv<=4 then
            clv2=4
        elseif lv>=5 and lv<=6 then
            clv2=6
        else
            clv2=8
        end
        local e01=Effect.CreateEffect(c)
        e01:SetType(EFFECT_TYPE_SINGLE)
        e01:SetCode(EFFECT_CHANGE_RANK)
        e01:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e01:SetValue(clv2)
        oc:RegisterEffect(e01)
        if oc:IsImmuneToEffect(e01) then effchk=true end
    end
    if not oc:HasLevel() and oc:IsType(TYPE_XYZ) then clv=clv2 end
	if effchk or not c:IsRelateToEffect(e) then return end
	Duel.BreakEffect()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rg=Duel.SelectMatchingCard(tp,s.filter12,tp,LOCATION_DECK,0,1,1,nil,c,oc,e,tp,clv)
	if #rg<1 then return end
	local cc=rg:GetFirst()
    if not Duel.SpecialSummonStep(cc,0,tp,tp,false,false,POS_FACEUP) then return end
	local e11=Effect.CreateEffect(c)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_ADD_TYPE)
	e11:SetValue(TYPE_TUNER)
	e11:SetReset(RESET_EVENT+RESETS_STANDARD)
	cc:RegisterEffect(e11)
	local e12=Effect.CreateEffect(c)
	e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_DISABLE)
	e12:SetReset(RESET_EVENT+RESETS_STANDARD)
	cc:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EFFECT_DISABLE_EFFECT)
	cc:RegisterEffect(e13)
	Duel.SpecialSummonComplete()

    c:SetStatus(STATUS_NO_LEVEL,false)
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_ADD_TYPE)
    e1:SetValue(TYPE_MONSTER)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CHANGE_RACE)
    e2:SetValue(oc:GetRace())
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    cc:RegisterEffect(e3)
    local e4=e1:Clone()
    e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e4:SetValue(oc:GetAttribute())
    c:RegisterEffect(e4)
    local e4=e3:Clone()
    cc:RegisterEffect(e4)
    local e6=e1:Clone()
    e6:SetCode(EFFECT_CHANGE_LEVEL)
    e6:SetValue(clv)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    cc:RegisterEffect(e7)
    local e8=e1:Clone()
    e8:SetCode(EFFECT_SET_ATTACK_FINAL)
    e8:SetValue(oc:GetAttack())
    c:RegisterEffect(e8)
    local e9=e8:Clone()
    cc:RegisterEffect(e9)
    local e10=e1:Clone()
    e10:SetCode(EFFECT_SET_DEFENSE_FINAL)
    e10:SetValue(oc:GetDefense())
    c:RegisterEffect(e10)
    local e10=e9:Clone()
    cc:RegisterEffect(e10)
    local sg=Group.FromCards(c,cc)
    Duel.BreakEffect()

	--synchro level
	-- local e14=Effect.CreateEffect(c)
	-- e14:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	-- e14:SetType(EFFECT_TYPE_SINGLE)
	-- e14:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	-- e14:SetOperation(s.synop)
	-- cc:RegisterEffect(e14,true)
    local exg=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,cc,c)
    local ft=Duel.GetLocationCountFromEx(tp,tp,cc,TYPE_FUSION)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	ft=math.min(ft,aux.CheckSummonGate(tp) or ft)
	ft=math.min(ft,3)
	local fg=aux.SelectUnselectGroup(exg,e,tp,1,ft,aux.dpcheck(s.gettype),1,tp,HINTMSG_SPSUMMON,nil,nil,true)
	if #fg<1 then e14:Reset() return end
    c:CancelToGrave()
    local reason=0
    for fc in aux.Next(fg) do
        if fc:IsType(TYPE_FUSION) then
            reason=reason|REASON_FUSION
        end
        if fc:IsType(TYPE_SYNCHRO) then
            reason=reason|REASON_SYNCHRO
        end
		fc:SetMaterial(sg)
	end
    if not fg:IsExists(Card.IsType,1,nil,TYPE_XYZ) then
        Duel.SendtoGrave(sg,REASON_EFFECT+REASON_MATERIAL+reason)
    end
    for fc in aux.Next(fg) do
	    local sumtype=0
        if fc:IsType(TYPE_XYZ) then
            sumtype=sumtype|SUMMON_TYPE_XYZ
            Duel.Overlay(fc,sg)
        end
        if fc:IsType(TYPE_FUSION) then
            sumtype=sumtype|SUMMON_TYPE_FUSION
        end
        if fc:IsType(TYPE_SYNCHRO) then
            sumtype=sumtype|SUMMON_TYPE_SYNCHRO
        end
        Duel.SpecialSummonStep(fc,sumtype,tp,tp,false,false,POS_FACEUP)
	end
    Duel.SpecialSummonComplete()
    for fc in aux.Next(fg) do
        fc:CompleteProcedure()
        if fc:IsLocation(LOCATION_MZONE) then
            fc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e3:SetCode(EVENT_PHASE+PHASE_END)
            e3:SetCountLimit(1)
            e3:SetRange(LOCATION_MZONE)
            e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
            e3:SetLabel(Duel.GetTurnCount()+1)
            e3:SetLabelObject(fc)
            e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
            e3:SetCondition(s.descon)
            e3:SetOperation(s.desop)
            fc:RegisterEffect(e3,true)
    
            local e11=Effect.CreateEffect(c)
            e11:SetDescription(aux.Stringid(68823957,1))
            e11:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
            e11:SetType(EFFECT_TYPE_QUICK_O)
            e11:SetCode(EVENT_CHAINING)
            e11:SetRange(LOCATION_MZONE)
            e11:SetCondition(s.condition3)
            e11:SetOperation(s.operation3)
            e11:SetReset(RESET_EVENT+RESETS_STANDARD)
            fc:RegisterEffect(e11,true)
        end
    end
    --e14:Reset()
end
function s.synop(e,tg,ntg,sg,lv,sc,tp)
	return sc:IsSetCard(0x1903),true
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(id)~=0 then
		return Duel.GetTurnCount()==e:GetLabel()
	else
		e:Reset()
		return false
	end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_RULE)
end

function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	return rp==1-tp and tc:IsSetCard(0x10ae)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=re:GetHandler()
	if rp==tp then return end
    Duel.ClearTargetCard()
	local op=re:GetOperation()
    if tg then tg(re,tp,eg,ep,ev,re,r,rp,1) end
	Duel.ChangeChainOperation(ev,function (ae,atp,aeg,aep,aev,are,ar,arp)
		op(ae,tp,aeg,aep,aev,are,ar,arp)
	end)
end

function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(Card.IsSetCard,nil,0x1903)>0
end
function s.gtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
end
function s.gop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft1=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	if not (ft1>0 or ft2>0) then return end
	local op = 0
	if ft1>0 and ft2>0 then
		op = Duel.SelectOption(tp, aux.Stringid(id, 3), aux.Stringid(id, 4)) 
	elseif ft2>0 then
		op=1
	else
		op=0
	end
    local loc=LOCATION_SZONE
    local ttp=0
    if op==0 then ttp=tp
    else ttp=1-tp end
    Duel.MoveToField(c,tp,ttp,loc,POS_FACEUP,true)
end