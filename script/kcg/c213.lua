local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

	--Cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.recon2)
	e3:SetOperation(s.thop2)
	c:RegisterEffect(e3)
end
s.listed_names={CARD_ASSAULT_MODE}

function s.recon2(e,tp,eg,ep,ev,re,r,rp)
    local rrealcode=e:GetHandler():GetRealCode()
	return not (re and re:GetHandler():IsCode(CARD_ASSAULT_MODE, 88332693)) and rrealcode<1
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re and re:GetHandler():IsCode(CARD_ASSAULT_MODE, 88332693) then return end
	local announce_filter={TYPE_SYNCHRO, OPCODE_ISTYPE, OPCODE_ALLOW_ALIASES}
	local code=Duel.AnnounceCard(tp, table.unpack(announce_filter))
	local tc=Duel.CreateToken(tp,code)
    local ocode=tc:GetOriginalCode()
    local acode=tc:GetOriginalAlias()
	local level=math.min(12,tc:GetLevel()+2)
	local ss={tc:GetOriginalSetCard()}
    local addset=false
    if #ss>3 then
        addset=true
    else
        table.insert(ss,0x104f)
    end
    local effcode=ocode
    local rrealcode,orcode,rrealalias=tc:GetRealCode()
    if rrealcode>0 then 
        code=orcode
        acode=orcode
        effcode=0
    elseif tc:IsOriginalType(TYPE_NORMAL) then
        effcode=0
    end
    if rrealcode>0 then
        c:SetEntityCode(code,nil,ss,TYPE_MONSTER+TYPE_EFFECT+TYPE_SPSUMMON,level,nil,nil,tc:GetTextAttack()+500,tc:GetTextDefense()+500,nil,nil,nil,false,id,effcode,213,tc)
        local te1={tc:GetFieldEffect()}
        local te2={tc:GetTriggerEffect()}
        for _,te in ipairs(te1) do
            if te:GetOwner()==tc then
                local te2=te:Clone()
                te2:SetOwner(c)
                if te:IsHasProperty(EFFECT_FLAG_CLIENT_HINT) then
                    local prop=te:GetProperty()
                    te2:SetProperty(prop&~EFFECT_FLAG_CLIENT_HINT)
                end
                c:RegisterEffect(te2,true)
                te:Reset()
            end
            if (te:GetRange()&LOCATION_PZONE)~=0 then
                te:Reset()
            end
        end
        local te2count=0
        for _,te in ipairs(te2) do
            if te:GetOwner()==tc then
                local te2=te:Clone()
                if (bit.band(te:GetType(),EFFECT_TYPE_QUICK_O)~=0 or bit.band(te:GetType(),EFFECT_TYPE_TRIGGER_O)~=0 or bit.band(te:GetType(),EFFECT_TYPE_IGNITION)~=0) and te:GetCondition() and te:GetOperation() then
                    te2:SetCondition(function(...) return true end)
                end
                te2:SetOwner(c)
                if te:IsHasProperty(EFFECT_FLAG_CLIENT_HINT) then
                    local prop=te:GetProperty()
                    te2:SetProperty(prop&~EFFECT_FLAG_CLIENT_HINT)
                end
                c:RegisterEffect(te2,true)
                te:Reset()
                te2count=1
            end
            if (te:GetRange()&LOCATION_PZONE)~=0 or te:IsHasType(EFFECT_TYPE_ACTIVATE) then
                te:Reset()
            end
        end
        if te2count>0 then
            local e1=Effect.CreateEffect(c)
            e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
            e1:SetDescription(aux.Stringid(213,1),true)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(213)
            c:RegisterEffect(e1)
        end
    elseif not aux.burstlist[acode] then
        c:SetEntityCode(code,nil,ss,TYPE_MONSTER+TYPE_EFFECT+TYPE_SPSUMMON,level,nil,nil,tc:GetTextAttack()+500,tc:GetTextDefense()+500,nil,nil,nil,true,id,effcode,213)
        local tec2 = {c:GetTriggerEffect()}
        local te2count=0
        for _, te in ipairs(tec2) do
            if te:GetOwner()==c then
                if (bit.band(te:GetType(),EFFECT_TYPE_QUICK_O)~=0 or bit.band(te:GetType(),EFFECT_TYPE_TRIGGER_O)~=0 or bit.band(te:GetType(),EFFECT_TYPE_IGNITION)~=0) and te:GetCondition() and te:GetOperation() then
                    local te2=te:Clone()
                    te:Reset()
                    te2:SetCondition(function(...) return true end)
                    c:RegisterEffect(te2,true)
                    te2count=1
                end
            end
        end
        if te2count>0 then
            local e1=Effect.CreateEffect(c)
            e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
            e1:SetDescription(aux.Stringid(213,1),true)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(213)
            c:RegisterEffect(e1)
        end
    else
        c:SetEntityCode(aux.burstlist[acode],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
        aux.CopyCardTable(aux.burstlist[acode],c)
        return
    end
    if addset then
        local e1=Effect.CreateEffect(tc)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e1:SetCode(EFFECT_ADD_SETCODE)
        e1:SetValue(0x104f)
        tc:RegisterEffect(e1)
    end
    aux.CopyCardTable(tc,c,false,"listed_names",CARD_ASSAULT_MODE,acode)
    c.__index.assault_mode=acode
	local tec2 = {c:GetTriggerEffect()}
	if tec2 then
		for _, temp in ipairs(tec2) do
			if (bit.band(temp:GetType(),EFFECT_TYPE_QUICK_O)~=0 or bit.band(temp:GetType(),EFFECT_TYPE_TRIGGER_O)~=0 or bit.band(temp:GetType(),EFFECT_TYPE_IGNITION)~=0) and temp:GetCondition() and temp:GetOperation() then
				local te2=temp:Clone()
				temp:Reset()
				te2:SetCondition(function(...) return true end)
				c:RegisterEffect(te2,true)
			else
				temp:Reset()
			end
		end
        local e1=Effect.CreateEffect(c)
        e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
        e1:SetDescription(aux.Stringid(213,1),true)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(213)
        c:RegisterEffect(e1)
	end
	--Special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(213,0),true,0,0,0,0,acode)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e4:SetCode(EVENT_DESTROYED)
	if rrealcode>0 then 
        e4:SetLabel(rrealalias)
    else
        e4:SetLabel(acode)
    end
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.spfilter(c,e,tp)
	local code=e:GetLabel()
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
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
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
