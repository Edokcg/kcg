--上古宝箱(ZCG)
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE) 
    e1:SetCategory(CATEGORY_DICE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
           --cannot be destroyed
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e11:SetRange(LOCATION_SZONE)
    e11:SetValue(s.efilter2)
    c:RegisterEffect(e11)
end
function s.efilter2(e,re)
    return re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) and not re:GetHandler():IsSetCard(0xa120)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.filter(c)
return c:IsSetCard(0xa120) and c:IsType(TYPE_MONSTER)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.TossDice(tp,1)
    local c=e:GetHandler()
    if d==1 then
        local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,0,nil)
        if #g>0 then
        local tc=g:GetFirst()   
        while tc do
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(200)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
            tc=g:GetNext()   
        end
       end
    elseif d==2 then
        local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,nil)
        if g:GetCount()>0 then
           local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
            Duel.SendtoDeck(tc,tp,2,REASON_EFFECT)
        end
    elseif d==3 then
         local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
        if g:GetCount()>0 then
            local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
            Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
            Duel.ShuffleDeck(tp)
            Duel.Draw(tp,1,REASON_EFFECT)
        end
  elseif d==4 then
        local g=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,nil)
        if g:GetCount()>0 then
           local tc=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
            Duel.GetControl(tc,tp)
        end
elseif d==5 then
   local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND,nil)
    if g:GetCount()>1 then
    local hg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_HAND,2,2,nil)
    Duel.SendtoGrave(hg,REASON_DISCARD+REASON_EFFECT)
    end
    else
      local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
        if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
        end
    end
end