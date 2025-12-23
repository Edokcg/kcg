--罪龍帝 (K)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_NOT_EXTRA)
	e0:SetValue(1)
	c:RegisterEffect(e0)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.spcon)  
	c:RegisterEffect(e1)

	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE)
	e100:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e100:SetRange(LOCATION_MZONE)
	e100:SetCode(EFFECT_CANNOT_DISABLE)
	e100:SetValue(1)
	c:RegisterEffect(e100)
	--特殊召唤不会被无效化
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e9)

	--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(s.descon)
	c:RegisterEffect(e2)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(s.atkvalue)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e5)

	--destroy
	-- local e11=Effect.CreateEffect(c)
	-- e11:SetDescription(aux.Stringid(37115575,1))
	-- e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	-- e11:SetRange(LOCATION_MZONE)
	-- e11:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	-- e11:SetCode(EVENT_BATTLE_DESTROYING)
	-- e11:SetCondition(s.bdcon)
	-- e11:SetTarget(s.detg)
	-- e11:SetOperation(s.deop)
	-- c:RegisterEffect(e11)

	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,0))
	e8:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetTarget(s.thtg)
	e8:SetOperation(s.thop)
	c:RegisterEffect(e8)

	--Destroy replace
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_DESTROY_REPLACE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCondition(s.desrepcon)
	e10:SetTarget(s.desreptg)
	e10:SetOperation(s.desrepop)
	c:RegisterEffect(e10)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(s.valfilter)
	c:RegisterEffect(e3)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e7)
end
s.listed_names={27564031,204}
s.listed_series={0x23}

function s.spfilter(c,type)
		return c:IsType(TYPE_MONSTER) and c:IsType(type) and c:IsSetCard(0x23)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(s.spfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,TYPE_FUSION)
	    and Duel.IsExistingMatchingCard(s.spfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,TYPE_SYNCHRO)
		and Duel.IsExistingMatchingCard(s.spfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,TYPE_XYZ)
		and Duel.GetLocationCountFromEx(e:GetHandlerPlayer(),e:GetHandlerPlayer(),nil,e:GetHandler())>0
end

function s.descon(e)
	return not (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,27564031),e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(27564031))
end

function s.atkvalue(e)
	return Duel.GetMatchingGroupCount(Card.IsRace,0,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil,RACE_DRAGON)*1000
end

-- function s.bdcon(e,tp,eg,ep,ev,re,r,rp)
-- 	local tc=eg:GetFirst()
-- 	local bc=tc:GetBattleTarget()
-- 	return tc:IsRelateToBattle() and tc:IsControler(tp) and tc:IsSetCard(0x23)
-- 		and bc:IsReason(REASON_BATTLE) and bc:IsType(TYPE_MONSTER) and bc:IsControler(1-tp) 
-- end
-- function s.defilter(c)
-- 	return c:IsFaceup()
-- end
-- function s.defilter2(c,e)
-- 	return c:IsFaceup() and not c:IsImmuneToEffect(e)
-- end
-- function s.detg(e,tp,eg,ep,ev,re,r,rp,chk)
-- 	if chk==0 then return true end
-- 	local g=Duel.GetMatchingGroup(s.defilter,tp,0,LOCATION_MZONE,nil)
-- 	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
-- 	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*800)
-- end
-- function s.deop(e,tp,eg,ep,ev,re,r,rp)
-- 	local g=Duel.GetMatchingGroup(s.defilter2,tp,0,LOCATION_MZONE,nil,e)
-- 	if Duel.Destroy(g,REASON_EFFECT)>0 then
-- 	  Duel.Damage(1-tp,g:GetCount()*800,REASON_EFFECT) end
-- end

function s.desrepcon(e,tp,eg,ep,ev,re,r,rp)
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return f1~=nil or f2~=nil 
end
function s.repfilter(c)
	return c:IsSetCard(0x23) and c:IsAbleToRemove()
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup()
		and Duel.IsExistingMatchingCard(s.repfilter,tp,LOCATION_GRAVE,0,1,c) end
	if Duel.SelectYesNo(tp,aux.Stringid(13707,6)) then
		return true
	else return false end
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
	local g=Duel.SelectMatchingCard(tp,s.repfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end

function s.valfilter(e,c)
	return -e:GetHandler():GetAttack()
end

function s.thfilter(c)
	return c:IsCode(204) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end