--游戏(ZCG)
function c77238000.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)	
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_SSET)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)	
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    c:RegisterEffect(e2)
	
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77238000,0))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND)
    e3:SetTarget(c77238000.tg)
    e3:SetOperation(c77238000.op)
    c:RegisterEffect(e3)

    --Atk
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetRange(LOCATION_HAND)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FIEND+RACE_SPELLCASTER))
    e4:SetValue(200)
    e4:SetCondition(c77238000.con)	
    c:RegisterEffect(e4)
    --Def
    local e5=e4:Clone()
    e5:SetCode(EFFECT_UPDATE_DEFENSE)
    e5:SetValue(200)
    c:RegisterEffect(e5)

    --Atk
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_UPDATE_ATTACK)
    e6:SetRange(LOCATION_HAND)
    e6:SetTargetRange(LOCATION_MZONE,0)
    e6:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FAIRY))
    e6:SetValue(-200)
    e6:SetCondition(c77238000.con)	
    c:RegisterEffect(e6)
    --Def
    local e7=e6:Clone()
    e7:SetCode(EFFECT_UPDATE_DEFENSE)
    e7:SetValue(-200)
    c:RegisterEffect(e7)	
	
    --damage
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e8:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
    e8:SetRange(LOCATION_HAND)
    e8:SetCountLimit(1)
    e8:SetCondition(c77238000.damcon)
    e8:SetOperation(c77238000.damop)
    c:RegisterEffect(e8)	
end
-------------------------------------------------------------------------------------
function c77238000.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return  not e:GetHandler():IsPublic() end
end
function c77238000.op(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_PUBLIC)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e:GetHandler():RegisterEffect(e1)
end
-------------------------------------------------------------------------------------
function c77238000.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPublic()
end
-------------------------------------------------------------------------------------
function c77238000.damcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp and e:GetHandler():IsPublic()
end
function c77238000.damop(e,tp,eg,ep,ev,re,r,rp)
    local lp=Duel.GetLP(tp)
    if lp>300 then
        Duel.SetLP(tp,lp-300)
    else
        Duel.SetLP(tp,0)
    end
end
