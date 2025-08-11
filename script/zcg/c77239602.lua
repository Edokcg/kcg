--植物的愤怒 魔树王
function c77239602.initial_effect(c)
    c:EnableReviveLimit()
	
    -- xyzop
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239602,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c77239602.xyzcon)
    e1:SetOperation(c77239602.xyzop)
    e1:SetValue(SUMMON_TYPE_XYZ)
    c:RegisterEffect(e1)	

    -- xyzop
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239602,1))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c77239602.xyzcon1)
    e2:SetOperation(c77239602.xyzop1)
    e2:SetValue(SUMMON_TYPE_XYZ)
    c:RegisterEffect(e2)	
	
    --destroy replace
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c77239602.reptg)
    e3:SetOperation(c77239602.repop)
    c:RegisterEffect(e3)	
end
------------------------------------------------------------------
function c77239602.hofilter(c, tp, xyzc, lv)
    if c:IsType(TYPE_TOKEN) or not c:IsCanBeXyzMaterial(xyzc) then return false end
    return c:IsRace(RACE_PLANT)
end
function c77239602.xyzcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return false end
    return Duel.IsExistingMatchingCard(c77239602.hofilter, tp, LOCATION_MZONE, 0, 5, nil, tp, c)
end
function c77239602.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
    local tp=c:GetControler()
    local mg = Duel.SelectMatchingCard(tp, c77239602.hofilter, tp, LOCATION_MZONE, 0, 5, 5, nil, tp, c)
    if mg:GetCount()<5 then return end
        c:SetMaterial(mg)
        Duel.Overlay(c, mg)
end
------------------------------------------------------------------
function c77239602.hofilter1(c,tp,xyzc,lv)
    if c:IsType(TYPE_TOKEN) or not c:IsCanBeXyzMaterial(xyzc) then return false end
    return c:IsSetCard(0xa90) and c:IsType(TYPE_MONSTER)
end
function c77239602.xyzcon1(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return false end
    return Duel.IsExistingMatchingCard(c77239602.hofilter1,tp,LOCATION_GRAVE,0,5,nil,tp,c)
end
function c77239602.xyzop1(e,tp,eg,ep,ev,re,r,rp,c)
    local tp=c:GetControler()
    local mg = Duel.SelectMatchingCard(tp,c77239602.hofilter1,tp,LOCATION_GRAVE,0,5,5,nil,tp,c)
    if mg:GetCount()<5 then return end
        c:SetMaterial(mg)
        Duel.Overlay(c,mg)
end
------------------------------------------------------------------
function c77239602.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    return Duel.SelectYesNo(tp,aux.Stringid(77239602,2))
end
function c77239602.repop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end













