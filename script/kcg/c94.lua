--Sin トゥルース·ドラゴン
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37115575,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROY)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	--selfdes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(s.descon)
	c:RegisterEffect(e7)

	--spson
	local e8=Effect.CreateEffect(c) 
	e8:SetType(EFFECT_TYPE_SINGLE) 
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE) 
	e8:SetCode(EFFECT_SPSUMMON_CONDITION) 
	e8:SetValue(aux.FALSE) 
	c:RegisterEffect(e8) 

	--destroy
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(37115575,1))
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e9:SetCode(EVENT_BATTLE_DESTROYING)
	e9:SetCondition(s.bdcon)
	e9:SetTarget(s.detg)
	e9:SetOperation(s.deop)
	c:RegisterEffect(e9)

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
end
s.listed_names={27564031}

function s.sumlimit(e,c)
	return c:IsSetCard(0x23)
end

function s.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0x23) and c:GetCode()~=37115575
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)~=0 then
		c:CompleteProcedure()
	end
end

function s.descon(e)
	return not (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,27564031),e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(27564031))
end

function s.bdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local bc=tc:GetBattleTarget()
	return tc:IsRelateToBattle() and tc:IsControler(tp) and tc:IsSetCard(0x23)
		and bc:IsReason(REASON_BATTLE) and bc:IsType(TYPE_MONSTER) and bc:IsControler(1-tp) 
end
function s.defilter(c)
	return c:IsFaceup() and aux.TRUE
end
function s.defilter2(c,e)
	return c:IsFaceup() and not c:IsImmuneToEffect(e)
end
function s.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.defilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*800)
end
function s.deop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.defilter2,tp,0,LOCATION_MZONE,nil,e)
	if Duel.Destroy(g,REASON_EFFECT)>0 then
	  Duel.Damage(1-tp,g:GetCount()*800,REASON_EFFECT) end
end

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
