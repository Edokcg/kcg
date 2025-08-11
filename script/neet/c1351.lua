--圣刻龙-孔斯龙
local s,id=GetID()
function s.initial_effect(c)
	--Normal monster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e2)
	--spsummon proc
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_SPSUMMON_PROC)
	e11:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e11:SetRange(LOCATION_DECK)
	e11:SetCountLimit(1,1351)
	e11:SetCondition(s.spcon)
	e11:SetCost(s.spcost)
	e11:SetOperation(s.spop)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	--lv change
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(1351,0))
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e12:SetCode(EVENT_SUMMON_SUCCESS)
	e12:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e12:SetCost(s.spcost)
	e12:SetTarget(s.tg)
	e12:SetOperation(s.op)
	c:RegisterEffect(e12)
	local e31=e12:Clone()
	e31:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e31)
	Duel.AddCustomActivityCounter(1351,ACTIVITY_SPSUMMON,s.counterfilter)
end
s.listed_series={0x69}
function s.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_DRAGON)
end
--spsummon proc
function s.spfilter1(c,tp)
	return c:IsSetCard(0x69)
	and c:IsType(TYPE_MONSTER)
	and c:IsReleasable()
end

function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(1351,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Release(g1,REASON_COST)
	Duel.ShuffleDeck(tp)
end
--lv change
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lv=e:GetHandler():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1351,1))
	e:SetLabel(Duel.AnnounceLevel(tp,1,8,lv))
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
