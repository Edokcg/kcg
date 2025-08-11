--千年智慧轮
function c77238293.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77238293.target)
    e1:SetOperation(c77238293.activate)
    c:RegisterEffect(e1)
	
	--
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c77238293.desreptg)
    e2:SetOperation(c77238293.desrepop)
    c:RegisterEffect(e2)	
	
    --
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60391791,0))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c77238293.atktg)
    e3:SetOperation(c77238293.atkop)
    c:RegisterEffect(e3)		
end
-------------------------------------------------------------------
function c77238293.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
        Duel.IsPlayerCanSpecialSummonMonster(tp,e:GetHandler():GetCode(),nil,0x11,0,0,0,0,0,POS_FACEUP) end
	e:GetHandler():SetTurnCounter(0)	
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77238293.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        or not Duel.IsPlayerCanSpecialSummonMonster(tp,e:GetHandler():GetCode(),nil,0x11,0,0,0,0,0,POS_FACEUP) then return end
    c:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPELL)
    Duel.SpecialSummon(c,1,tp,tp,true,false,POS_FACEUP)
end
-------------------------------------------------------------------
function c77238293.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReason(REASON_BATTLE) and c:IsOnField() and c:IsFaceup() end
    if c then
        return true
    else return false end		
end
function c77238293.desrepop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    ct=ct+1
    c:SetTurnCounter(ct)
    if ct>1 then
        Duel.Destroy(c,REASON_RULE)
    end
end
-------------------------------------------------------------------
function c77238293.filter(c)
    return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAttackPos() --and c:IsAttackable()
end
function c77238293.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and c77238293.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77238293.filter,tp,0,LOCATION_MZONE,1,nil)
	and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>1 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,c77238293.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c77238293.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,tc)
		local dc=g:GetFirst()
		Duel.CalculateDamage(tc,dc)
    end
end

