--黑暗大邪神 佐克·内洛法
local s, id = GetID()
function s.initial_effect(c)
    aux.god(c,3,id,0)

    local e001 = Effect.CreateEffect(c)
    e001:SetType(EFFECT_TYPE_SINGLE)
    e001:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
    e001:SetCode(805)
    e001:SetValue(3)
    c:RegisterEffect(e001)

	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,900000098)
	
	local e00=Effect.CreateEffect(c)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetCode(EFFECT_REMOVE_TYPE)
	e00:SetValue(TYPE_FUSION)
	c:RegisterEffect(e00)

	--特殊召唤方式
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	
	--特殊召唤限制
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)

	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_FIELD)
	e18:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e18:SetCode(EFFECT_CANNOT_LOSE_LP)
	e18:SetRange(LOCATION_MZONE)
	e18:SetTargetRange(1,0)
	e18:SetValue(1)
	c:RegisterEffect(e18)
	local e19=e18:Clone()
	e19:SetCode(EFFECT_CANNOT_LOSE_DECK)
	c:RegisterEffect(e19)
	local e20=e18:Clone()
	e20:SetCode(EFFECT_CANNOT_LOSE_EFFECT)
	c:RegisterEffect(e20)
	
	--战斗时直接破坏对方怪兽和造成伤害
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(900000098,2))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_START)
	e5:SetTarget(s.destg)
	e5:SetOperation(s.desop)
	c:RegisterEffect(e5)
	
	--直接攻击时攻击力变成无限
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_INF_ATTACK)
	e7:SetCondition(s.condtion)
	c:RegisterEffect(e7)
	
	--特殊召唤时场上怪兽全部变成里侧守备
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetTarget(s.postg)
	e8:SetOperation(s.posop)
	c:RegisterEffect(e8)
	
	--每回合投掷骰子发动效果
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(900000098,2))
	e9:SetCategory(CATEGORY_DESTROY+CATEGORY_DICE)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetCost(s.diccost)
	e9:SetTarget(s.dictg)
	e9:SetOperation(s.dicop)
	c:RegisterEffect(e9)
	
	--离场时决斗失败
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetOperation(s.sucop)
	c:RegisterEffect(e11)

	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetOperation(s.lose)
	c:RegisterEffect(e6)
end
s.listed_series={0x2222}
s.listed_names={900000097}
-----------------------------------------------------------------------------------------------------------
function s.spfilter(c)
	return c:IsSetCard(0x2222) and (not c:IsOnField() or c:IsFaceup())
end
function s.spfilter2(c)
	return c:IsCode(900000097) and (not c:IsOnField() or c:IsFaceup())
end
function s.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(s.spfilter,c:GetControler(),LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>7 and Duel.IsExistingMatchingCard(s.spfilter2,c:GetControler(),LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
end
--------------------------------------------------
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tc:GetAttack())
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then 
      Duel.Destroy(tc,REASON_RULE+REASON_EFFECT) 
      local g=Duel.GetOperatedGroup():GetFirst()
      if g then Duel.Damage(1-tp,g:GetAttack(),REASON_EFFECT) end 
      end
end
---------------------------------------------------------------------------------------------------------
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttackTarget()~=nil end
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,d:GetAttack())
end

function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
--------------------------------------------------------------------------------------------------------
function s.condtion(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
      and Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil
end
---------------------------------------------------------------------------------------------------------
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,sg:GetCount(),0,0)
end

function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if sg:GetCount()>0 then
		Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE,0,POS_FACEDOWN_DEFENSE,0)
	end
end
--------------------------------------------------------------------------------------------------------
function s.diccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end

function s.dictg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	if g1:GetCount()~=0 and g2:GetCount()~=0 then
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	end
end

function s.dicop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.TossDice(tp,1)
	if d==1 or d==2 or d==3 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,e:GetHandler())
		Duel.Destroy(g,REASON_RULE+REASON_EFFECT)
	elseif d==6 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,e:GetHandler())
		Duel.Destroy(g,REASON_RULE+REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		Duel.Destroy(g,REASON_RULE+REASON_EFFECT)
	end
end
-------------------------------------------------------------------------------------------------------
function s.lose(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(1-tp,0x4)
end