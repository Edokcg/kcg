--青眼の光龍
function c77239008.initial_effect(c)
    c:EnableReviveLimit()
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c77239008.spcon)
    e2:SetOperation(c77239008.spop)
    c:RegisterEffect(e2)
    --atkup
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(c77239008.val)
    c:RegisterEffect(e3)

    --disable effect
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_CHAIN_SOLVING)
    e4:SetRange(LOCATION_MZONE)
    e4:SetOperation(c77239008.disop2)
    c:RegisterEffect(e4)
    --disable
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_DISABLE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(0xa,0xa)
    e5:SetTarget(c77239008.distg2)
    c:RegisterEffect(e5)
    --self destroy
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_SELF_DESTROY)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(0xa,0xa)
    e6:SetTarget(c77239008.distg2)
    c:RegisterEffect(e6)
	
    local e7=Effect.CreateEffect(c)
    e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e7:SetCode(EVENT_BE_BATTLE_TARGET)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(c77239008.condition)
    e7:SetTarget(c77239008.target)
    e7:SetOperation(c77239008.activate)
    c:RegisterEffect(e7)	
end
------------------------------------------------------------------------------------
function c77239008.spcon(e,c)
    if c==nil then return true end
    return Duel.CheckReleaseGroup(c:GetControler(),Card.IsCode,1,nil,23995346)
end
function c77239008.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(c:GetControler(),Card.IsCode,1,1,nil,23995346)
    Duel.Release(g,REASON_COST)
end
function c77239008.val(e,c)
    return Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_GRAVE,0,nil,RACE_DRAGON)*300
end
------------------------------------------------------------------------------------
function c77239008.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if re:GetHandler():IsRelateToEffect(re) then
                Duel.NegateEffect(ev)
            end
        end
    end
end
function c77239008.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:GetCardTarget():IsContains(e:GetHandler())
end
------------------------------------------------------------------------------------
function c77239008.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function c77239008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tg=Duel.GetAttacker()
    if chkc then return chkc==tg end
    if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
    Duel.SetTargetCard(tg)
end
function c77239008.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetAttacker()
    if tc:IsRelateToEffect(e) then
         Duel.NegateAttack()
    end
end

