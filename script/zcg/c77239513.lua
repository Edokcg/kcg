--女子佣兵 吸血魔(ZCG)
function c77239513.initial_effect(c)
    --summon & set with no tribute
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239513,0))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(c77239513.ntcon)
    e1:SetOperation(c77239513.ntop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_PROC)
    c:RegisterEffect(e2)

    --atkup
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(c77239513.val)
    c:RegisterEffect(e3)

    --damage
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77239513,0))
    e4:SetCategory(CATEGORY_DAMAGE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetCode(EVENT_BATTLE_DESTROYING)
    e4:SetCondition(aux.bdogcon)
    e4:SetTarget(c77239513.sptg)
    e4:SetOperation(c77239513.spop)
    c:RegisterEffect(e4)
end	
--------------------------------------------------------------
function c77239513.ntcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c77239513.ntop(e,tp,eg,ep,ev,re,r,rp,c)
    --change base attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetReset(RESET_EVENT+0xff0000)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetValue(0)
    c:RegisterEffect(e1)
end
--------------------------------------------------------------
function c77239513.val(e,c)
    return Duel.GetMatchingGroupCount(c77239513.filter,c:GetControler(),LOCATION_MZONE,0,nil)*2000
end
function c77239513.filter(c)
    return c:IsFaceup() and c:IsSetCard(0xa80)
end
--------------------------------------------------------------
function c77239513.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and bc:IsCanBeSpecialSummoned(e,0,1-tp,false,false) end
    Duel.SetTargetCard(bc)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,bc,1,0,0)
end
function c77239513.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,1-tp,1-tp,false,false,POS_FACEUP)
        local dam=tc:GetAttack()/2
        Duel.Damage(1-tp,dam,REASON_EFFECT)		
    end
end



