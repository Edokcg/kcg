--奥利哈刚 拉菲鲁(ZCG)
function c77239208.initial_effect(c)	
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239208.spcon)
    c:RegisterEffect(e1)
	
    --Activate
    local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
    e2:SetTarget(c77239208.target)
    e2:SetOperation(c77239208.operation)
    c:RegisterEffect(e2)
end
-----------------------------------------------------------------------
function c77239208.spcon(e,c)
    if c==nil then return true end
    return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
        and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
-----------------------------------------------------------------------
function c77239208.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,564)
    local ac=Duel.AnnounceCard(tp)
    e:SetLabel(ac)
    e:GetHandler():SetHint(CHINT_CARD,ac)
end
function c77239208.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ac=e:GetLabel()
    local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
    local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    Duel.ConfirmCards(tp,hg)
    if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
       local tc=g:GetFirst()
       if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_ADD_SETCODE)
            e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
            e1:SetRange(LOCATION_MZONE)
            e1:SetReset(RESET_EVENT+0x1ff0000)
            e1:SetValue(0xa50)
            tc:RegisterEffect(e1,true)
       end
    end
end

