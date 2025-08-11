--邪心教典
function c77239014.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c77239014.cost)
    c:RegisterEffect(e1)
	
	--spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c77239014.mtcon)
    --e2:SetTarget(c77239014.target)
    e2:SetOperation(c77239014.mtop)
    c:RegisterEffect(e2)
	
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetOperation(c77239014.desop)
    e3:SetLabelObject(e2)
    c:RegisterEffect(e3)	
end
-----------------------------------------------------------------
function c77239014.cfilter(c)
    return (c:IsCode(77239015) or c:IsCode(77239016) or c:IsCode(77239017) or c:IsCode(77239018) or c:IsCode(77239019)) and c:IsAbleToRemoveAsCost() and (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_SZONE) or c:IsFaceup())
end
function c77239014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(c77239014.cfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
    if chk==0 then return g:GetClassCount(Card.GetCode)>=5 end
    local rg=Group.CreateGroup()
    for i=1,5 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local tc=g:Select(tp,1,1,nil):GetFirst()
        if tc then
            rg:AddCard(tc)
            g:Remove(Card.IsCode,nil,tc:GetCode())
        end
    end
    Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
------------------------------------------------------------------------------------------
function c77239014.mtcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=1-tp
end
function c77239014.filter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end

--[[function c77239014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_EXTRA) and c77239014.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
        and Duel.IsExistingTarget(c77239014.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_EXTRA,0)>1
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c77239014.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77239014.mtop1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.CheckLPCost(1-tp,800) and Duel.SelectYesNo(1-tp,aux.Stringid(77239019,0)) then
        Duel.PayLPCost(1-tp,800)
    else
       local tc=Duel.GetFirstTarget()
       if tc:IsRelateToEffect(e) then
            Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
            tc:CompleteProcedure()
            c:SetCardTarget(tc)
            e:SetLabelObject(tc)
            tc:RegisterFlagEffect(77239014,RESET_EVENT+0x1fe0000,0,0)
            c:RegisterFlagEffect(77239014,RESET_EVENT+0x1020000,0,0)			
       end 
    end
end]]


function c77239014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239014.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c77239014.mtop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.CheckLPCost(1-tp,800) and Duel.SelectYesNo(1-tp,aux.Stringid(77239014,0)) then
        Duel.PayLPCost(1-tp,800)
    else
	local g1=Duel.GetMatchingGroup(c77239014.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	Duel.ConfirmCards(1-tp,g1)
	local sg=g1:Filter(c77239014.filter,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sdg=sg:Select(tp,sg:GetCount(),sg:GetCount(),nil)
		Duel.SpecialSummon(sdg,0,tp,tp,true,true,POS_FACEUP)
		end
    end
end
---------------------------------------------------------------------------------------
function c77239014.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject():GetLabelObject()
    if tc and tc:GetFlagEffect(77239014)~=0 and e:GetHandler():GetFlagEffect(77239014)~=0 then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end


