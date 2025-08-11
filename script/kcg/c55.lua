--覇王龍ズァーク
local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	
	--spsummon condition
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_SINGLE)
	e15:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e15:SetCode(EFFECT_SPSUMMON_CONDITION)
	e15:SetValue(s.splimit)
	c:RegisterEffect(e15)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(13331639)
	c:RegisterEffect(e2)
    
	--spsummon immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e6)
	
	--destroy all
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(13331639,1))
	e7:SetProperty(EFFECT_FLAG_DELAY)   
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetTarget(s.destg)
	e7:SetOperation(s.desop)
	c:RegisterEffect(e7)

	--immune
	local e16=Effect.CreateEffect(c)
	e16:SetType(EFFECT_TYPE_FIELD)
	e16:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e16:SetCode(EFFECT_IMMUNE_EFFECT)
	e16:SetRange(LOCATION_MZONE)
	e16:SetTargetRange(LOCATION_MZONE,0)
	e16:SetValue(s.efilter)
	c:RegisterEffect(e16)		
	
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_SINGLE)
	e22:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e22:SetRange(LOCATION_MZONE)
	e22:SetCode(EFFECT_UNRELEASABLE_EFFECT)
	e22:SetCondition(s.indcon)   
	e22:SetValue(s.refilter)
	c:RegisterEffect(e22)	
	
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(s.indcon)   
	e9:SetValue(1)
	c:RegisterEffect(e9)
	local e19=e9:Clone()
	e19:SetCode(EFFECT_IMMUNE_EFFECT)
	e19:SetValue(s.imfilter)
	c:RegisterEffect(e19)
	-- local e12=e9:Clone()
	-- e12:SetCode(EFFECT_CANNOT_BE_MATERIAL)
	-- e12:SetValue(aux.AND(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_RITUAL),s.imfilter))
	-- c:RegisterEffect(e12)
	
	--special summon
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(id,2))
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetProperty(EFFECT_FLAG_DELAY)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e10:SetCode(EVENT_BATTLE_DESTROYING)
	e10:SetCondition(aux.bdocon)
	e10:SetTarget(s.sptg2)
	e10:SetOperation(s.spop2)
	c:RegisterEffect(e10)
    
 	--handes
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(48739166,0))
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_TO_HAND)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCondition(s.hdcon)
	e11:SetOperation(s.hdop)
	c:RegisterEffect(e11)
    
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(27439792,1))
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_DESTROYED)
    e8:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCondition(s.pencon)
	e8:SetTarget(s.pentg)
	e8:SetOperation(s.penop)
	c:RegisterEffect(e8)
end
s.listed_series={0x20f8}
s.listed_names={56,57}

function s.splimit(e, se, sp, st)
	return se:GetHandler():IsCode(56,57)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if chk==0 then return g:GetCount()>0 end
	local tc=g:GetFirst()
	local tatk=0
	while tc do
	local atk=tc:GetAttack()
	if atk<0 then atk=0 end
	tatk=tatk+atk
	tc=g:GetNext() end  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tatk)	
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
		local g2=Duel.GetOperatedGroup()
		Duel.BreakEffect()
		local tc=g2:GetFirst()
		local tatk=0
		while tc do
		local atk=tc:GetPreviousAttackOnField()
		if atk<0 then atk=0 end
		tatk=tatk+atk
		tc=g2:GetNext() end 
		Duel.Damage(1-tp,tatk,REASON_EFFECT)
	end
end

function s.efilter(e,te)
	--local tc=te:GetHandler()
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() 
	and (te:IsActiveType(TYPE_XYZ+TYPE_FUSION+TYPE_SYNCHRO+TYPE_RITUAL) and te:IsActiveType(TYPE_MONSTER))
end

function s.ndcfilter(c)
	return c:IsFaceup() 
	and (c:IsType(TYPE_XYZ+TYPE_FUSION+TYPE_SYNCHRO+TYPE_RITUAL) and c:IsType(TYPE_MONSTER))
end

function s.indfilter(c,tpe)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(tpe) and c:IsType(TYPE_MONSTER)
end
function s.indcon(e)
	return Duel.IsExistingMatchingCard(s.indfilter,0,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_RITUAL+TYPE_LINK)
end

function s.refilter(e,te)
	return not (te:GetOwner():IsCode(57) and te:GetOwnerPlayer()==e:GetOwnerPlayer())
end

function s.leaveChk(c,category)
	local ex,tg=Duel.GetOperationInfo(0,category)
	return ex and tg~=nil and tg:IsContains(c)
end
function s.imfilter(e,te)
	local c=e:GetOwner()
	return ((c:GetDestination()>0 and c:GetReasonEffect()==te)
		or (s.leaveChk(c,CATEGORY_TOHAND) or s.leaveChk(c,CATEGORY_DESTROY) or s.leaveChk(c,CATEGORY_REMOVE)
		or s.leaveChk(c,CATEGORY_TODECK) or s.leaveChk(c,CATEGORY_RELEASE) or s.leaveChk(c,CATEGORY_TOGRAVE)))
		and not (te:GetHandler():IsLocation(LOCATION_EXTRA) and te:GetCode()==EFFECT_SPSUMMON_PROC) and e:GetOwner()~=te:GetOwner() and not te:GetHandler():IsCode(57)
end

function s.spfilter(c,e,tp,rp)
	if c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,rp,nil,c)<=0 then return false end
	return c:IsSetCard(SET_SUPREME_KING_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return loc~=0 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,2,nil,e,tp,rp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,2,2,nil,e,tp,rp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end

function s.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.hdop(e,tp,eg,ep,ev,re,r,rp)
	local zg=eg:Filter(function(c) return not c:IsType(TYPE_TOKEN) and c:IsControler(1-tp) end,nil)
	if zg:GetCount()<1 then return end
	Duel.Overlay(e:GetHandler(), zg)
end

function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.sppfilter2(c,e,tp)
	return c:IsCode(76794549) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sppfilter2,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_HAND)
end
function s.sppfilter(c)
	return c:IsCode(57) and c:IsAbleToHand()
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SendtoDeck(c, tp, 2, REASON_EFFECT)
        local sg=Duel.SelectMatchingCard(tp,s.sppfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
        if sg:GetCount()<1 then return end
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
        local g=Duel.SelectMatchingCard(tp,s.sppfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
        if g:GetCount()<1 then return end
        Duel.SendtoHand(g, tp, REASON_EFFECT)
	end
end