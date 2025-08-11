--地狱之巨神兵(Z)
function c77239103.initial_effect(c)
	--通召条件
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c77239103.ttcon)
	e1:SetOperation(c77239103.ttop)
	--e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c77239103.setcon)
	c:RegisterEffect(e2)
	--召唤不会被无效
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)

	--攻击力提升
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetValue(c77239103.value)
    c:RegisterEffect(e4)
	
    --不会被效果破坏
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e5:SetValue(1)
    c:RegisterEffect(e5)
	
    --不会被战斗破坏
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e6:SetValue(1)
    c:RegisterEffect(e6)
	
	--伤害
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_DAMAGE)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)	
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(c77239103.cost)
	e7:SetTarget(c77239103.damtg)
	e7:SetOperation(c77239103.damop)
	c:RegisterEffect(e7)
	
	--战斗伤害为0
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e9:SetValue(1)
    c:RegisterEffect(e9)
end
---------------------------------------------------------------
function c77239103.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c77239103.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c77239103.setcon(e,c,minc)
	if not c then return true end
	return false
end
-------------------------------------------------------------
function c77239103.value(e,c)
    return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,nil,TYPE_MONSTER)*800
end
-------------------------------------------------------------
function c77239103.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 and Duel.CheckReleaseGroup(tp,nil,2,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,nil,2,2,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c77239103.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(4000)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,4000)
end
function c77239103.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
