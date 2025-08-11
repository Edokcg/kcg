--升阶魔法 往昔调合 (KDIY)
local s,id=GetID()
function s.initial_effect(c)
	--Spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series = {0x1903, 0x902}

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end

function s.filter1(c,mc,e,tp)
	if c:IsFacedown() then return false end
    local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,1-tp,c)
	return res
end

function s.filter2(c,e,tp,tc)
	return c:IsSetCard(0x1903) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
    and tc:IsCanBeXyzMaterial(c)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter1(chkc,c,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,1-tp,LOCATION_MZONE,0,1,nil,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter1,1-tp,LOCATION_MZONE,0,1,1,nil,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local lv=tc:GetLevel()
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
        if tc:HasLevel() then
            local e01=Effect.CreateEffect(c)
            e01:SetType(EFFECT_TYPE_SINGLE)
            e01:SetCode(EFFECT_CHANGE_LEVEL)
            e01:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            e01:SetValue(clv)
            tc:RegisterEffect(e01)
            if tc:IsImmuneToEffect(e01) then effchk=true end
        end
        if tc:HasRank() then
            lv=tc:GetRank()
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
            tc:RegisterEffect(e01)
            if tc:IsImmuneToEffect(e01) then effchk=true end
        end
        if effchk or not c:IsRelateToEffect(e) then return end
		Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
        local sc=g:GetFirst()
        if sc then
            local mg=tc:GetOverlayGroup()
            if #mg~=0 then
                Duel.Overlay(sc,mg)
            end
            sc:SetMaterial(tc)
            Duel.Overlay(sc,tc)
            if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,1-tp,1-tp,false,false,POS_FACEUP) then
                sc:CompleteProcedure()
                local e11=Effect.CreateEffect(e:GetHandler())
                e11:SetDescription(aux.Stringid(68823957,1))
                e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
                e11:SetType(EFFECT_TYPE_QUICK_F)
                e11:SetCode(EVENT_CHAINING)
                e11:SetRange(LOCATION_MZONE)
                e11:SetCondition(s.condition3)
                e11:SetOperation(s.operation3)
                e11:SetReset(RESET_EVENT+RESETS_STANDARD)
                sc:RegisterEffect(e11,true)
            end
        end
	end
end

function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	return re and rp==1-tp and tc:IsSetCard(0x10ae)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=re:GetHandler()
    local tg=re:GetTarget()
    local ae,atp,aeg,aep,aev,are,ar,arp=tc:CheckActivateEffect(false,true,true)
	if rp==tp then return end
    Duel.ClearTargetCard()
	local op=re:GetOperation()
    if tg then tg(ae,tp,aeg,aep,aev,are,ar,arp,1) end
	Duel.ChangeChainOperation(ev,function (ae,atp,aeg,aep,aev,are,ar,arp)
		op(ae,tp,aeg,aep,aev,are,ar,arp)
	end)
end