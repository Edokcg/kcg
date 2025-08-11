--真红眼闪光龙
function c77238782.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c77238782.spcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)	
	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetCondition(c77238782.damcon)
	e4:SetOperation(c77238782.damop)
	c:RegisterEffect(e4)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetCondition(c77238782.con)  
	c:RegisterEffect(e3)
	
	--spsumon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77238782,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(function(e) return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1 end)
	e5:SetOperation(c77238782.activate)
	c:RegisterEffect(e5)	
end
c77238782.listed_series={0x3b}
--------------------------------------------------------------------
function c77238782.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
--------------------------------------------------------------------
function c77238782.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3b)
end
function c77238782.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.GetAttackTarget()==nil and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c77238782.spfilter,tp,LOCATION_MZONE,0,3,nil)
end
function c77238782.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,Duel.GetLP(1-tp))
end
function c77238782.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77238782.spfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,3,nil)
end
--------------------------------------------------------------------
function c77238782.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c77238782.spcon2)
	e1:SetOperation(c77238782.spop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c77238782.filter(c,e,tp)
	return c:IsSetCard(0x3b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77238782.spcon2(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77238782.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
end
function c77238782.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(c77238782.filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
	if ft<=0 or #tg==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,ft,ft,nil)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end