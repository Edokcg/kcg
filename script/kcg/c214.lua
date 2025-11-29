--バスター・モード・ゼロ
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
s.listed_series={0x104f}
s.listed_names={CARD_ASSAULT_MODE}

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.cfilter(c,e,tp,ft)
	return c:IsType(TYPE_SYNCHRO) and (ft>0 or (c:GetSequence()<5 and c:IsControler(tp))) 
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c:GetCode(),e,tp)
end
function s.spfilter(c,tcode,e,tp)
	--if c:IsOriginalCode(213) and aux.burstlist[tcode] then return false end
	return c:IsSetCard(0x104f)
	and ((c.assault_mode and c.assault_mode==tcode) or c:IsOriginalCode(213))
	and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return ft>-1 and Duel.CheckReleaseGroupCost(tp,s.cfilter,1,false,nil,nil,e,tp,ft)
	end
	local rg=Duel.SelectReleaseGroupCost(tp,s.cfilter,1,1,false,nil,nil,e,tp,ft)
	e:SetLabelObject(rg:GetFirst())
	Duel.SetTargetParam(rg:GetFirst():GetCode())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,code,e,tp):GetFirst()
	if not tc then return end
	local rg=e:GetLabelObject()
	if not rg then return end
	local ocode=rg:GetOriginalCode()
	local acode=rg:GetOriginalAlias()
	if tc:IsOriginalCode(213) and not aux.burstlist[code] then
		local level=math.min(12,rg:GetOriginalLevel()+2)
		local ss={rg:GetOriginalSetCard()}
        local addset=false
        if #ss>3 then
            addset=true
		else
			table.insert(ss,0x104f)
		end
		local effcode=ocode
		local rrealcode,orcode,rrealalias=rg:GetRealCode()
		if rrealcode>0 then 
			ocode=orcode
			acode=orcode
			effcode=0
		elseif rg:IsOriginalType(TYPE_NORMAL) then
			effcode=0
		end
        if rrealcode>0 then
            tc:SetEntityCode(ocode,nil,ss,TYPE_MONSTER+TYPE_EFFECT+TYPE_SPSUMMON,level,nil,nil,rg:GetTextAttack()+500,rg:GetTextDefense()+500,nil,nil,nil,false,213,effcode,213,rg)
            local te1={rg:GetFieldEffect()}
            local te2={rg:GetTriggerEffect()}
            for _,te in ipairs(te1) do
                if te:GetOwner()==rg then
                    local te2=te:Clone()
                    te2:SetOwner(tc)
                    if te:IsHasProperty(EFFECT_FLAG_CLIENT_HINT) then
                        local prop=te:GetProperty()
                        te2:SetProperty(prop&~EFFECT_FLAG_CLIENT_HINT)
                    end
                    tc:RegisterEffect(te2,true)
                end
            end
            local te2count=0
            for _,te in ipairs(te2) do
                if te:GetOwner()==rg then
                    local te2=te:Clone()
                    if (bit.band(te:GetType(),EFFECT_TYPE_QUICK_O)~=0 or bit.band(te:GetType(),EFFECT_TYPE_TRIGGER_O)~=0 or bit.band(te:GetType(),EFFECT_TYPE_IGNITION)~=0) and te:GetCondition() and te:GetOperation()
                    and ((te:GetRange()&LOCATION_PZONE)==0 and not te:IsHasType(EFFECT_TYPE_ACTIVATE)) then
                        te2:SetCondition(function(...) return true end)
                    end
                    te2:SetOwner(tc)
                    if te:IsHasProperty(EFFECT_FLAG_CLIENT_HINT) then
                        local prop=te:GetProperty()
                        te2:SetProperty(prop&~EFFECT_FLAG_CLIENT_HINT)
                    end
                    tc:RegisterEffect(te2,true)
                    te2count=1
                end
            end
            if te2count>0 then
                local e1=Effect.CreateEffect(tc)
                e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
                e1:SetDescription(aux.Stringid(213,1),true)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(213)
                tc:RegisterEffect(e1)
            end
        else
            tc:SetEntityCode(ocode,nil,ss,TYPE_MONSTER+TYPE_EFFECT+TYPE_SPSUMMON,level,nil,nil,rg:GetTextAttack()+500,rg:GetTextDefense()+500,nil,nil,nil,true,213,effcode,213)
            local tec2 = {tc:GetTriggerEffect()}
            local te2count=0
            for _, te in ipairs(tec2) do
                if te:GetOwner()==tc then
                    if (bit.band(te:GetType(),EFFECT_TYPE_QUICK_O)~=0 or bit.band(te:GetType(),EFFECT_TYPE_TRIGGER_O)~=0 or bit.band(te:GetType(),EFFECT_TYPE_IGNITION)~=0) and te:GetCondition() and te:GetOperation()
                    and ((te:GetRange()&LOCATION_PZONE)==0 and not te:IsHasType(EFFECT_TYPE_ACTIVATE)) then
                        local te2=te:Clone()
                        te2:SetCondition(function(...) return true end)
                        tc:RegisterEffect(te2,true)
                        te2count=1
                    end
                end
            end
            if te2count>0 then
                local e1=Effect.CreateEffect(tc)
                e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
                e1:SetDescription(aux.Stringid(213,1),true)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(213)
                tc:RegisterEffect(e1)
            end
        end
        if addset then
            local e1=Effect.CreateEffect(tc)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
            e1:SetCode(EFFECT_ADD_SETCODE)
            e1:SetValue(0x104f)
            tc:RegisterEffect(e1)
        end
		aux.CopyCardTable(tc,"listed_names",CARD_ASSAULT_MODE,acode)
		tc.__index.assault_mode=acode
		--Special summon
		local e4=Effect.CreateEffect(tc)
		e4:SetDescription(aux.Stringid(213,0),true,0,0,0,0,rg:GetOriginalAlias())
		e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
		e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e4:SetCode(EVENT_DESTROYED)
		if rrealcode>0 then 
            e4:SetLabel(rrealalias)
        else
            e4:SetLabel(acode)
        end
		e4:SetCondition(s.spcon2)
		e4:SetTarget(s.sptg2)
		e4:SetOperation(s.spop2)
		tc:RegisterEffect(e4)
    elseif tc:IsOriginalCode(213) then
        tc:SetEntityCode(aux.burstlist[code],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
	end
	Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	tc:CompleteProcedure()
end

function s.setfilter(c,cd)
	return c:IsCode(CARD_ASSAULT_MODE) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		g:GetFirst():RegisterEffect(e1)
	end
end


function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.spfilter2(c,e,tp)
	local code=e:GetLabel()
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end