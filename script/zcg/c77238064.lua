--碎魂者之最后的战斗(ZCG)
local s,id=GetID()
function s.initial_effect(c)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetCode(EVENT_CUSTOM+id)
    e2:SetCost(s.cost)
    e2:SetTarget(s.target)
    e2:SetOperation(s.activate)
    c:RegisterEffect(e2)
    local e93=Effect.CreateEffect(c)
    e93:SetType(EFFECT_TYPE_FIELD)
    e93:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e93:SetCode(EFFECT_FORBIDDEN)
    e93:SetRange(LOCATION_SZONE)
    e93:SetTargetRange(0,0xff)
    e93:SetTarget(s.bantg93)
    c:RegisterEffect(e93)
    local e94=Effect.CreateEffect(c)
    e94:SetType(EFFECT_TYPE_SINGLE)
    e94:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e94:SetRange(LOCATION_SZONE)
    e94:SetCode(EFFECT_IMMUNE_EFFECT)
    e94:SetValue(s.efilter94)
    c:RegisterEffect(e94)
    --
    local e95 = Effect.CreateEffect(c)
    e95:SetType(EFFECT_TYPE_FIELD)
    e95:SetCode(EFFECT_DISABLE)
    e95:SetRange(LOCATION_SZONE)
    e95:SetTargetRange(0, LOCATION_ONFIELD)
    e95:SetTarget(s.distg95)
    c:RegisterEffect(e95)
  --disable effect
    local e103=Effect.CreateEffect(c)
    e103:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e103:SetCode(EVENT_ADJUST)
    e103:SetRange(LOCATION_SZONE)
    e103:SetOperation(s.disop99)
    c:RegisterEffect(e103)
    s.GlobalCheck(s,function()
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
        ge1:SetCode(EVENT_DAMAGE)
        ge1:SetOperation(s.zeroop)
        Duel.RegisterEffect(ge1,0)
        local ge2=ge1:Clone()
        ge2:SetCode(EVENT_ADJUST)
        Duel.RegisterEffect(ge2,0)
    end)
    if not s.global_e_check then
       s.global_e_check=true
       s[0]={} 
       s[1]={}  
       s[0][0]=nil 
       s[0][1]=nil 
       s[1][0]=nil 
       s[1][1]=nil 
       s[0][2]=false 
       s[1][2]=false 
       s[0][3]=true 
       s[1][3]=true 
       s[0][4]=false
       s[1][4]=false
       s[0][5]=0
       s[1][5]=0
    end
end
function s.zeroop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tp=c:GetControler()
    if Duel.GetLP(tp)>0 then return false end
    if s[tp][2] and not s[tp][4] then  
       s[tp][5]=s[tp][5]+1
        if s[tp][5]>=3 then   
            if s[tp][0] then
                s[tp][0]:Reset()
            end
            if s[tp][1] then
                s[tp][1]:Reset()    
            end
            s[tp][5]=0
       end
    end
    if Duel.GetLP(0)<=0 and not s[tp][2] then
        s[tp][0]=Effect.CreateEffect(c)
        s[tp][0]:SetType(EFFECT_TYPE_FIELD)
        if aux.IsKCGScript then
            s[tp][0]:SetCode(EFFECT_CANNOT_LOSE_LP)
        else 
             s[tp][0]:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
        end
        s[tp][0]:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        s[tp][0]:SetTargetRange(1,0)
        Duel.RegisterEffect(s[tp][0],0)
        Duel.RaiseEvent(Duel.GetMatchingGroup(aux.TRUE,0,0xff,0,nil),EVENT_CUSTOM+id,nil,0,0,0,0)
        s[tp][2]=true 
    end
    if Duel.GetLP(1)<=0 and not s[tp][2] then
        s[tp][1]=Effect.CreateEffect(c)
        s[tp][1]:SetType(EFFECT_TYPE_FIELD)
        if aux.IsKCGScript then
            s[tp][1]:SetCode(EFFECT_CANNOT_LOSE_LP)
        else 
            s[tp][1]:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
        end
        s[tp][1]:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        s[tp][1]:SetTargetRange(1,0)
        Duel.RegisterEffect(s[tp][1],1)
        Duel.RaiseEvent(Duel.GetMatchingGroup(aux.TRUE,0,0xff,0,nil),EVENT_CUSTOM+id,nil,0,0,1,0)
        s[tp][2]=true 
    end
    if s[tp][2] and not s[tp][3] then
           s[tp][2]=false
           s[tp][3]=false
           if s[tp][0] then
              s[tp][0]:Reset()
           end
           if s[tp][1] then
              s[tp][1]:Reset()  
           end
    end
end
function s.GlobalCheck(s,func)
    if not s.global_check then
        s.global_check=true
        func()
    end
end
function s.filter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local iz1=Effect.CreateEffect(e:GetHandler())
    iz1:SetType(EFFECT_TYPE_FIELD)
    if aux.IsKCGScript then
        iz1:SetCode(EFFECT_CANNOT_LOSE_LP)
    else 
        iz1:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
    end
    iz1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    iz1:SetTargetRange(1,1)
    Duel.RegisterEffect(iz1,tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    s[tp][3]=false 
    if chk==0 then return Duel.GetCurrentPhase()<PHASE_BATTLE end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    s[tp][3]=true 
    s[tp][4]=true 
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.Destroy(sg,REASON_EFFECT)
    local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft1>0 then
        if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft1=1 end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,ft1,ft1,nil,e,tp)
        if g:GetCount()>0 then
            local tc=g:GetFirst()
            while tc do
                local c=e:GetHandler()
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_DISABLE)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
                tc:RegisterEffect(e1,true)
                local e2=Effect.CreateEffect(c)
                e2:SetType(EFFECT_TYPE_SINGLE)
                e2:SetCode(EFFECT_DISABLE_EFFECT)
                e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
                tc:RegisterEffect(e2,true)
                Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP)
                tc=g:GetNext()
            end
        end
    end
    local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
    if ft2>0 then
        if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ft2=1 end
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(1-tp,s.filter,tp,0,LOCATION_DECK,ft2,ft2,nil,e,1-tp)
        if g:GetCount()>0 then
            local tc=g:GetFirst()
            while tc do
                local c=e:GetHandler()
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_DISABLE)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
                tc:RegisterEffect(e1,true)
                local e2=Effect.CreateEffect(c)
                e2:SetType(EFFECT_TYPE_SINGLE)
                e2:SetCode(EFFECT_DISABLE_EFFECT)
                e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
                tc:RegisterEffect(e2,true)
                Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP)
                tc=g:GetNext()
            end
        end
    end
    Duel.SpecialSummonComplete()
    local e5=Effect.CreateEffect(e:GetHandler())
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetTargetRange(1,0)
    e5:SetCode(EFFECT_SKIP_M1)
    Duel.RegisterEffect(e5,tp)
    --must attack
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_MUST_ATTACK)
    e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetOperation(s.checkop)
    Duel.RegisterEffect(e1,tp)
    Duel.ResetFlagEffect(tp,id+1)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
    local t1=Duel.GetFieldGroupCount(0,LOCATION_MZONE,0)
    local t2=Duel.GetFieldGroupCount(1,LOCATION_MZONE,0)
    if t1>t2 then
        Duel.Win(0,0x16)
    elseif t2>t1 then
        Duel.Win(1,0x16)   
    else
        Duel.Win(PLAYER_NONE,0x16)
    end
end
function s.efilter94(e,te)
    return te:GetHandler():IsSetCard(0xa70)
end
function s.bantg93(e,c)
    return c:IsSetCard(0xa70) and (not c:IsOnField() or c:GetRealFieldID()>e:GetFieldID())
end
function s.distg95(e, c)
    return c:IsSetCard(0xa70)
end
function s.filter96(c)
    return c:IsSetCard(0xa70)
end
function s.filter99(c)
    return c:IsSetCard(0xa70) and c:IsFaceup()
end
function s.disop99(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(s.filter99,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    if sg:GetCount()>0 then
            Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
    end
end





