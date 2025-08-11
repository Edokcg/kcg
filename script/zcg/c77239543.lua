--佣灵的意识
function c77239543.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77239543.target)
    e1:SetOperation(c77239543.activate)
    c:RegisterEffect(e1)
end
-------------------------------------------------------------
function c77239543.spfilter(c,code)
    return c:IsCode(code) and c:IsAbleToRemoveAsCost()
end
function c77239543.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return 
	    Duel.IsExistingTarget(c77239543.spfilter,tp,LOCATION_GRAVE,0,1,nil,77239506) and
        Duel.IsExistingTarget(c77239543.spfilter,tp,LOCATION_GRAVE,0,1,nil,77239507) and 
        Duel.IsExistingTarget(c77239543.spfilter,tp,LOCATION_GRAVE,0,1,nil,77239510) and 
        Duel.IsExistingTarget(c77239543.spfilter,tp,LOCATION_GRAVE,0,1,nil,77239509) and 
        Duel.IsExistingTarget(c77239543.spfilter,tp,LOCATION_GRAVE,0,1,nil,77239505) and 
		Duel.IsExistingTarget(c77239543.spfilter,tp,LOCATION_GRAVE,0,1,nil,77239508) end
end
function c77239543.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g1=Duel.SelectTarget(tp,c77239543.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,77239506)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g2=Duel.SelectTarget(tp,c77239543.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,77239507)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g3=Duel.SelectTarget(tp,c77239543.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,77239510)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g4=Duel.SelectTarget(tp,c77239543.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,77239509)   
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g5=Duel.SelectTarget(tp,c77239543.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,77239505)	
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g6=Duel.SelectTarget(tp,c77239543.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,77239508)	
	g1:Merge(g2)
    g1:Merge(g3)
    g1:Merge(g4)	
    g1:Merge(g5)
    g1:Merge(g6)
    if Duel.Remove(g1,POS_FACEUP,REASON_COST) then
        Duel.SetLP(1-tp,0)	    
	end
end