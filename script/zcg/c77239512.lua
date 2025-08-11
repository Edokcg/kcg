--女子佣兵 玄冰(ZCG)
function c77239512.initial_effect(c)
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_START)
    e1:SetTarget(c77239512.destg)
    e1:SetOperation(c77239512.desop)
    c:RegisterEffect(e1) 	
end
-----------------------------------------------------------------
function c77239512.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if tc==c then tc=Duel.GetAttackTarget() end
    if chk==0 then return tc and tc:IsFaceup() and tc:GetAttack()>=c:GetAttack() and tc:IsAttribute(ATTRIBUTE_WATER) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c77239512.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if tc==c then tc=Duel.GetAttackTarget() end
    if tc:IsRelateToBattle() and tc:GetAttack()>=c:GetAttack() then
        Duel.Destroy(tc,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
        e1:SetDescription(aux.Stringid(77239512,0))
        e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetRange(LOCATION_GRAVE)
        e1:SetCountLimit(1)
        e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
        e1:SetCondition(c77239512.con)
        e1:SetOperation(c77239512.op)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,1)        
		tc:RegisterEffect(e1)
		c:RegisterFlagEffect(77239512,0,0,0) 
		c:SetTurnCounter(0)
    end
end
function c77239512.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
--[[function c77239512.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    ct=ct+1
    c:SetTurnCounter(ct)
    if ct>=1 then
        Duel.SpecialSummon(c,0,1-tp,1-tp,false,false,POS_FACEUP)
		c:ResetFlagEffect(77239512)
        e:Reset()
    end
end]]

function c77239512.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SpecialSummon(c,0,1-tp,1-tp,true,true,POS_FACEUP)
end