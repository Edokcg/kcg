--冥界之王 阿努比斯
local s, id = GetID()
function s.initial_effect(c)
    aux.god(c,1,id,0)

    local e001 = Effect.CreateEffect(c)
    e001:SetType(EFFECT_TYPE_SINGLE)
    e001:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
    e001:SetCode(805)
    e001:SetValue(2)
    c:RegisterEffect(e001)

	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,900000025)
	
	local e00=Effect.CreateEffect(c)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetCode(EFFECT_NOT_EXTRA)
	e00:SetValue(1)
	c:RegisterEffect(e00)

	--特殊召唤方式
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(900000025,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	--特召成功时除外双方卡组和墓地所有怪兽
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(900000025,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
	
	--表侧表示时攻守变成4000
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(4000)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e5)
	
	--除外场上所有卡片
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(900000025,2))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCost(s.recost)
	e6:SetTarget(s.retg)
	e6:SetOperation(s.reop)
	c:RegisterEffect(e6)
	
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
	
	--离场时决斗失败
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(s.sucop)
	c:RegisterEffect(e8)
	
	--玩家不会受到战斗伤害
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(1,0)
	e9:SetValue(0)
	c:RegisterEffect(e9)
	
	--玩家不会受到效果伤害
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_CHANGE_DAMAGE)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetRange(LOCATION_MZONE)
	e10:SetTargetRange(1,0)
	e10:SetValue(s.damval)
	c:RegisterEffect(e10)
	
	--卡组抽完不会输掉
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_DRAW_COUNT)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTargetRange(1,0)
	e11:SetValue(s.dc)
	c:RegisterEffect(e11)
end
s.listed_names={id, 87997872}

------------------------------------------------------------------------------------------------------------
function s.cfilter(c,tp)
	return c:IsFaceup() and c:IsCode(87997872) and c:GetPreviousControler()==tp
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)
		e:GetHandler():CompleteProcedure()
	end
end
--------------------------------------------------
function s.filter(c)
	return c:IsType(TYPE_MONSTER)
end

function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,LOCATION_DECK+LOCATION_GRAVE,1,nil) end
	local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,LOCATION_DECK+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end

function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,LOCATION_DECK+LOCATION_GRAVE,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_RULE+REASON_EFFECT)
end
-------------------------------------------------------------------------------------------------------------------------------------------
function s.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end

function s.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
end

function s.reop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_RULE+REASON_EFFECT)
end
-------------------------------------------------------------------------------------------------------------------------------------------
function s.sucop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,8888888)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetOperation(s.lose)
	e:GetHandler():RegisterEffect(e1)
end

function s.lose(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(1-tp,0x4)
end
-------------------------------------------------------------------------------------------------------------------------------------------
function s.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end
-------------------------------------------------------------------------------------------------------------------------------------------
function s.dc(e)
	local tp=e:GetHandler():GetControler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then
		return 1
		else
		return 0
	end
end
