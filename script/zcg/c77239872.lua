--翼神龙 马利克的邪念
function c77239872.initial_effect(c)
    c:EnableReviveLimit()
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c77239872.spcon)
    e2:SetOperation(c77239872.spop)
    c:RegisterEffect(e2)
    local e02=Effect.CreateEffect(c)
	e02:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e02:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e02:SetCode(EVENT_SPSUMMON_SUCCESS)
	e02:SetOperation(c77239872.atkop1)
	c:RegisterEffect(e02)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e3)
    --summon success
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetOperation(c77239872.sumsuc)
    c:RegisterEffect(e4)	
	
    --魔法·陷阱发动无效并破坏
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_CHAIN_SOLVING)
    e5:SetRange(LOCATION_MZONE)
    e5:SetOperation(c77239872.disop2)
    c:RegisterEffect(e5)
    --[[disable
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_DISABLE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(0,LOCATION_SZONE)
    e6:SetTarget(c77239872.distg2)
    c:RegisterEffect(e6)
    --self destroy
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetCode(EFFECT_SELF_DESTROY)
    e7:SetRange(LOCATION_MZONE)
    e7:SetTargetRange(0,LOCATION_SZONE)
    e7:SetTarget(c77239872.distg2)
    c:RegisterEffect(e7)]]

    --damage
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_DAMAGE)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetCode(EVENT_BATTLE_DESTROYING)
    e6:SetCondition(c77239872.damcon)
    e6:SetTarget(c77239872.damtg)
    e6:SetOperation(c77239872.damop)
    c:RegisterEffect(e6)	
end
---------------------------------------------------------------------------
function c77239872.tlimit(c)
    return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(4)
end
--[[function c77239872.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3
        and Duel.CheckReleaseGroup(c:GetControler(),c77239872.tlimit,3,nil)
end
function c77239872.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(c:GetControler(),c77239872.tlimit,3,3,nil)
    Duel.Release(g,REASON_COST)
end]]

function c77239872.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local a=Duel.GetMatchingGroupCount(c77239872.tlimit,tp,LOCATION_MZONE,0,nil)
	return a>=3 and (Duel.GetLocationCount(tp,LOCATION_MZONE)>=-3)
end
function c77239872.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp, LOCATION_MZONE)<-3 then return end	
	local g=Duel.SelectMatchingCard(c:GetControler(),c77239872.tlimit,c:GetControler(),LOCATION_ONFIELD,0,3,3,nil)
	Duel.Release(g,REASON_COST)
	  local g2=Duel.GetOperatedGroup()
	  local tc=g2:GetFirst()
	  local tatk=0
	  local tdef=0
	  while tc do
	  local atk=tc:GetAttack()
	  local def=tc:GetDefense()
	  if atk<0 then atk=0 end
	  if def<0 then def=0 end
	  tatk=tatk+atk 
	  tdef=tdef+def 
	  tc=g2:GetNext() end
	ATK=tatk
	DEF=tdef
end
function c77239872.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(DEF)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
end
---------------------------------------------------------------------------
function c77239872.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
---------------------------------------------------------------------------
function c77239872.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp~=tp then
        if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
            Duel.Destroy(re:GetHandler(),REASON_EFFECT)
        end
    end
end
--[[function c77239872.distg2(e,c)
    return c:IsHasType(EFFECT_TYPE_ACTIVATE)
end]]
---------------------------------------------------------------------------
function c77239872.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c77239872.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local bc=e:GetHandler():GetBattleTarget()
    Duel.SetTargetCard(bc)
    local dam=bc:GetAttack()
    if dam<0 then dam=0 end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(dam)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c77239872.damop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
        local dam=tc:GetAttack()
        if dam<0 then dam=0 end
        Duel.Damage(p,dam+1000,REASON_EFFECT)
    end
end



