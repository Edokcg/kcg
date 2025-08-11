--罪 範式(KCG)
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.filter(c,e)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and not c:IsImmuneToEffect(e)
    and ((c:GetOriginalLevel()>=7 and c:GetOriginalLevel()<=10) or (c:GetOriginalRank()>=7 and c:GetOriginalRank()<=10))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil,e) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil,e):GetFirst()
	if c:IsRelateToEffect(e) and tc then
        if Duel.SendtoDeck(tc,tp,2,REASON_RULE+REASON_EFFECT)<1 then return end
        local code=0
        if tc:IsCode(79856792,1546123,89631139,44508094,74677422,10000010,10000020,57793869,6007213) then
            if tc:IsCode(79856792) then
                code=88
            elseif tc:IsCode(1546123) then
                code=89
            elseif tc:IsCode(89631139) then
                code=90
            elseif tc:IsCode(44508094) then
                code=91
            elseif tc:IsCode(74677422) then
                code=92
            elseif tc:IsCode(10000010) then
                code=129
            elseif tc:IsCode(10000020) then
                code=131                    
            elseif tc:IsCode(57793869) then
                code=132                    
            elseif tc:IsCode(6007213) then
                code=133
            end
            c:SetEntityCode(code,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
            aux.CopyCardTable(code,c)
        else
            local ocode=tc:GetOriginalCode()
            local acode=tc:GetOriginalAlias()
            local ss={tc:GetOriginalSetCard()}
            local addset=false
            if #ss>3 then
                addset=true
            else
                table.insert(ss,0x23)
            end
            local gtype=0
            if (tc:GetOriginalType() & TYPE_EXTRA) then gtype=1 end
            local effcode=ocode
            local rrealcode,orcode,rrealalias=tc:GetRealCode()
            if rrealcode>0 then 
                ocode=orcode
                acode=orcode
                effcode=0
            end
            if rrealcode>0 then
                c:SetEntityCode(ocode,nil,ss,TYPE_MONSTER+TYPE_EFFECT+TYPE_SPSUMMON,nil,nil,nil,nil,nil,nil,nil,nil,false,102,effcode,102,tc)
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
                end
                for _,te in ipairs(te2) do
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
                end
            else
                c:SetEntityCode(ocode,nil,ss,TYPE_MONSTER+TYPE_EFFECT+TYPE_SPSUMMON,nil,nil,nil,nil,nil,nil,nil,nil,true,102,effcode,102)
            end
            if addset then
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
                e1:SetCode(EFFECT_ADD_SETCODE)
                e1:SetValue(0x23)
                c:RegisterEffect(e1,true)
            end
            aux.CopyCardTable(tc,c,false,"listed_names",27564031,acode)
            local e1=Effect.CreateEffect(c)
            e1:SetDescription(aux.Stringid(102,gtype+1),true,0,0,0,0,acode,true)
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetCode(EFFECT_SPSUMMON_PROC)
            e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
            e1:SetRange(LOCATION_HAND)
            e1:SetLabel(acode)
            e1:SetCondition(s.spcon2)
            e1:SetOperation(s.spop2)
            c:RegisterEffect(e1,true)
            local e2=Effect.CreateEffect(c)
            e2:SetDescription(aux.Stringid(102,0),true,0,0,0,0,0,true)
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
		c:CancelToGrave()
		Duel.SendtoHand(c,tp,REASON_EFFECT)
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