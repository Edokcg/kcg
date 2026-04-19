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
        else
            aux.sinspop(tp,c,tc)
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