--海聂默斯之爪(ZCG)
function c77238990.initial_effect(c)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77238990.spcon)
    c:RegisterEffect(e1)
	
    --unaffectable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetValue(c77238990.efilter)
    c:RegisterEffect(e2)

    --Activate
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c77238990.target)
    e3:SetOperation(c77238990.activate)
    c:RegisterEffect(e3)
end
----------------------------------------------------------------------
function c77238990.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
----------------------------------------------------------------------
function c77238990.efilter(e,re)
    return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end
----------------------------------------------------------------------
function c77238990.tgfilter(c,e,tp)
    return c:IsFaceup() and c:IsCanBeFusionMaterial()
        and Duel.IsExistingMatchingCard(c77238990.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode())
end
function c77238990.spfilter(c,e,tp,code)
    return c:ListsCodeAsMaterial(code) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c77238990.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc==0 then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77238990.tgfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingTarget(c77238990.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c77238990.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c77238990.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanBeFusionMaterial() and not tc:IsImmuneToEffect(e) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=Duel.SelectMatchingCard(tp,c77238990.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetCode())
        local sc=sg:GetFirst()
        if sc then
            sc:SetMaterial(Group.FromCards(tc))
			sc:SetMaterial(Group.FromCards(e:GetHandler()))
            Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            Duel.BreakEffect()
            Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
            sc:CompleteProcedure()
        end
    end
end


