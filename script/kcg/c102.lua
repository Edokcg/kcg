--罪龍 (K)
local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(s.descon)
	c:RegisterEffect(e2)

	--spson
	-- local e3=Effect.CreateEffect(c)
	-- e3:SetType(EFFECT_TYPE_SINGLE)
	-- e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	-- e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	-- e3:SetValue(aux.FALSE)
	-- c:RegisterEffect(e3)

    local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(s.recon2)
	e4:SetOperation(s.thop2)
	c:RegisterEffect(e4)
end

function s.spfilter(c)
	return c:GetOriginalLevel()>=7 and c:GetOriginalLevel()<=10 
        and c:IsRace(RACE_DRAGON) and c:IsAbleToGraveAsCost() 
		-- and not c:IsCode(79856792) and not c:IsCode(1546123) and not c:IsCode(89631139) and not c:IsCode(44508094) and not c:IsCode(74677422) and not c:IsCode(10000010) and not c:IsCode(10000020) and not c:IsCode(57793869) and not c:IsCode(6007213)
		and not c:IsSetCard(0x23)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,c:GetControler(),LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,c)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,c)
	if #tg<1 then return end
	if Duel.SendtoGrave(tg,REASON_COST)>0 then
		local g=tg:GetFirst()
        local ocode=g:GetOriginalCode()
        local acode=g:GetOriginalAlias()
		local ss={g:GetOriginalSetCard()}
        local addset=false
        if #ss>3 then
            addset=true
        else
            table.insert(ss,0x23)
        end
		local gtype=0
		if (g:GetOriginalType() & TYPE_EXTRA) then gtype=1 end
        local effcode=ocode
        local rrealcode,orcode,rrealalias=g:GetRealCode()
        if rrealcode>0 then 
            ocode=orcode
            acode=orcode
            effcode=0
        end
        if rrealcode>0 then
            c:SetEntityCode(ocode,nil,ss,TYPE_MONSTER+TYPE_EFFECT+TYPE_SPSUMMON,nil,nil,nil,nil,nil,nil,nil,nil,false,id,effcode,102,g)
            local te1={g:GetFieldEffect()}
            local te2={g:GetTriggerEffect()}
            for _,te in ipairs(te1) do
                if te:GetOwner()==g then
                    local te2=te:Clone()
                    te2:SetOwner(c)
                    if te:IsHasProperty(EFFECT_FLAG_CLIENT_HINT) then
                        local prop=te:GetProperty()
                        te2:SetProperty(prop&~EFFECT_FLAG_CLIENT_HINT)
                    end
                    c:RegisterEffect(te2,true)
                    te:Reset()
                end
            end
            for _,te in ipairs(te2) do
                if te:GetOwner()==g then
                    local te2=te:Clone()
                    te2:SetOwner(c)
                    if te:IsHasProperty(EFFECT_FLAG_CLIENT_HINT) then
                        local prop=te:GetProperty()
                        te2:SetProperty(prop&~EFFECT_FLAG_CLIENT_HINT)
                    end
                    c:RegisterEffect(te2,true)
                    te:Reset()
                end
            end
        elseif not aux.sinlist[acode] then
            c:SetEntityCode(ocode,nil,ss,TYPE_MONSTER+TYPE_EFFECT+TYPE_SPSUMMON,nil,nil,nil,nil,nil,nil,nil,nil,true,id,effcode,102)
        else
            c:SetEntityCode(aux.sinlist[acode],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
            aux.CopyCardTable(aux.sinlist[acode],c)
            return
        end
        if addset then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
            e1:SetCode(EFFECT_ADD_SETCODE)
            e1:SetValue(0x23)
            c:RegisterEffect(e1,true)
        end
        aux.CopyCardTable(g,c,false,"listed_names",27564031,acode)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,gtype+1),true,0,0,0,0,acode,true)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_HAND)
		e1:SetLabel(acode)
		e1:SetCondition(s.spcon2)
		e1:SetOperation(s.spop2)
		c:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
        e2:SetDescription(aux.Stringid(id,0),true,0,0,0,0,0,true)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_SELF_DESTROY)
		e2:SetCondition(s.descon)
		c:RegisterEffect(e2,true)
        local e3=Effect.CreateEffect(c)
		e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UNSUMMONABLE_CARD)
		c:RegisterEffect(e3,true)
        local te1={c:GetFieldEffect()}
        for _,te in ipairs(te1) do
            if (te:GetRange()&LOCATION_PZONE)~=0 then
                te:Reset()
            end
            if (te:GetCode()==EFFECT_INDESTRUCTABLE or te:GetCode()==EFFECT_INDESTRUCTABLE_EFFECT or te:GetCode()==EFFECT_INDESTRUCTABLE_COUNT) and (not te:GetRange() or (te:GetRange()&LOCATION_MZONE)~=0) then
                local e1=te:Clone()
                local val=te:GetValue()
                e1:SetValue(function (ate,atre,...)
                    if type(val)=="function" then
                        return val(ate,atre,...) and atre~=e2
                    else
                        if val==1 then return atre~=e2 end
                    end
                end)
                c:RegisterEffect(e1)
                te:Reset()
            end
        end
        local te2={c:GetTriggerEffect()}
        for _,te in ipairs(te2) do
            if (te:GetRange()&LOCATION_PZONE)~=0 or te:IsHasType(EFFECT_TYPE_ACTIVATE) then
                te:Reset()
            end
        end
	end
end

function s.spfilter2(c,code)
	return c:IsCode(code) and c:IsAbleToGraveAsCost()
end
function s.spcon2(e,c)
	if c==nil then return true end
	local label=e:GetLabel()
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		   and Duel.IsExistingMatchingCard(s.spfilter2,c:GetControler(),LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,c,label)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	local label=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,c,label)
	if #tg<1 then return end
	Duel.SendtoGrave(tg,REASON_COST)
end

function s.descon(e)
	return not (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,27564031),e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(27564031))
end

function s.sumlimit(e,c)
	return c:IsSetCard(0x23)
end

function s.efilter(e,te)
    local rrealcode=e:GetHandler():GetRealCode()
	return te:GetHandler()==e:GetHandler()
end

function s.recon2(e,tp,eg,ep,ev,re,r,rp)
	return not (re and re:GetHandler()==e:GetOwner()) and rrealcode<1
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re and re:GetHandler()==e:GetOwner() then return end
	local announce_filter={RACE_DRAGON, OPCODE_ISRACE, 6, OPCODE_ISLEVELLARGER, OPCODE_AND, 11, OPCODE_ISLEVELSMALLER, OPCODE_AND, OPCODE_ALLOW_ALIASES}
	local code=Duel.AnnounceCard(tp, table.unpack(announce_filter))
	local g=Duel.CreateToken(tp,code)
    local ocode=g:GetOriginalCode()
    local acode=g:GetOriginalAlias()
    local ss={g:GetOriginalSetCard()}
    local addset=false
    if #ss>3 then
        addset=true
    else
        table.insert(ss,0x23)
    end
    local gtype=0
    if (g:GetOriginalType() & TYPE_EXTRA) then gtype=1 end
    local effcode=ocode
    local rrealcode,orcode,rrealalias=g:GetRealCode()
    if rrealcode>0 then 
        ocode=orcode
        acode=orcode
        effcode=0
    end
    if rrealcode>0 then
        c:SetEntityCode(ocode,nil,ss,TYPE_MONSTER+TYPE_EFFECT+TYPE_SPSUMMON,nil,nil,nil,nil,nil,nil,nil,nil,false,id,effcode,102,g)
        local te1={g:GetFieldEffect()}
        local te2={g:GetTriggerEffect()}
        for _,te in ipairs(te1) do
            if te:GetOwner()==g then
                local te2=te:Clone()
                te2:SetOwner(c)
                if te:IsHasProperty(EFFECT_FLAG_CLIENT_HINT) then
                    local prop=te:GetProperty()
                    te2:SetProperty(prop&~EFFECT_FLAG_CLIENT_HINT)
                end
                c:RegisterEffect(te2,true)
                te:Reset()
            end
        end
        for _,te in ipairs(te2) do
            if te:GetOwner()==g then
                local te2=te:Clone()
                te2:SetOwner(c)
                if te:IsHasProperty(EFFECT_FLAG_CLIENT_HINT) then
                    local prop=te:GetProperty()
                    te2:SetProperty(prop&~EFFECT_FLAG_CLIENT_HINT)
                end
                c:RegisterEffect(te2,true)
                te:Reset()
            end
        end
    elseif not aux.sinlist[acode] then
        c:SetEntityCode(ocode,nil,ss,TYPE_MONSTER+TYPE_EFFECT+TYPE_SPSUMMON,nil,nil,nil,nil,nil,nil,nil,nil,true,id,effcode,102)
    else
        c:SetEntityCode(aux.sinlist[acode],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
        aux.CopyCardTable(aux.sinlist[acode],c)
        return
    end
    if addset then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e1:SetCode(EFFECT_ADD_SETCODE)
        e1:SetValue(0x23)
        c:RegisterEffect(e1,true)
    end
    aux.CopyCardTable(g,c,false,"listed_names",27564031,acode)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,gtype+1),true,0,0,0,0,acode,true)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
    e1:SetRange(LOCATION_HAND)
    e1:SetLabel(acode)
    e1:SetCondition(s.spcon2)
    e1:SetOperation(s.spop2)
    c:RegisterEffect(e1,true)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0),true,0,0,0,0,0,true)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_SELF_DESTROY)
    e2:SetCondition(s.descon)
    c:RegisterEffect(e2,true)
    local e3=Effect.CreateEffect(c)
    e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_UNSUMMONABLE_CARD)
    c:RegisterEffect(e3,true)
    local te1={c:GetFieldEffect()}
    for _,te in ipairs(te1) do
        if (te:GetRange()&LOCATION_PZONE)~=0 then
            te:Reset()
        end
        if (te:GetCode()==EFFECT_INDESTRUCTABLE or te:GetCode()==EFFECT_INDESTRUCTABLE_EFFECT or te:GetCode()==EFFECT_INDESTRUCTABLE_COUNT) and (not te:GetRange() or (te:GetRange()&LOCATION_MZONE)~=0) then
            local e1=te:Clone()
            local val=te:GetValue()
            e1:SetValue(function (ate,atre,...)
                if type(val)=="function" then
                    return val(ate,atre,...) and atre~=e2
                else
                    if val==1 then return atre~=e2 end
                end
            end)
            c:RegisterEffect(e1)
            te:Reset()
        end
    end
    local te2={c:GetTriggerEffect()}
    for _,te in ipairs(te2) do
        if (te:GetRange()&LOCATION_PZONE)~=0 or te:IsHasType(EFFECT_TYPE_ACTIVATE) then
            te:Reset()
        end
    end
end