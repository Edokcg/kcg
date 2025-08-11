--覇王龍ズァーク
local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,s.fusfilter1,s.fusfilter2,s.fusfilter3,s.fusfilter4)
	Pendulum.AddProcedure(c,false)
	
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.AND(s.splimit,aux.fuslimit))
	c:RegisterEffect(e1)
	
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(s.limval)
	c:RegisterEffect(e2)

	--special summon
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_FIELD)
	e21:SetCode(EFFECT_SPSUMMON_PROC)
	e21:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e21:SetRange(LOCATION_PZONE)
	e21:SetCondition(s.sppcon)
	e21:SetOperation(s.sppop)
	c:RegisterEffect(e21)
	
	--destroy all
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13331639,1))
	e4:SetProperty(EFFECT_FLAG_DELAY)   
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCost(s.descost)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)
	
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetValue(s.efilter)
	c:RegisterEffect(e5)	
	
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
	e9:SetCode(EFFECT_INDESTRUCTABLE)
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
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,2))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_BATTLE_DESTROYING)
	e7:SetCondition(aux.bdocon)
	e7:SetTarget(s.sptg2)
	e7:SetOperation(s.spop2)
	c:RegisterEffect(e7)
	
	--handes
	local e20=Effect.CreateEffect(c)
	e20:SetDescription(aux.Stringid(58481572,0))
	e20:SetCategory(CATEGORY_DESTROY)
	e20:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e20:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e20:SetCode(EVENT_TO_HAND)
	e20:SetRange(LOCATION_MZONE)
	e20:SetCondition(s.hdcon)
	e20:SetTarget(s.hdtg)
	e20:SetOperation(s.hdop)
	c:RegisterEffect(e20)   
	
	--pendulum
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(13331639,3))
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCondition(s.pencon)
	e8:SetTarget(s.pentg)
	e8:SetOperation(s.penop)
	c:RegisterEffect(e8)
end
s.listed_series={0x20f8}
s.listed_names={48}
s.miracle_synchro_fusion=true

function s.fusfilter1(c,fc,sumtype,tp)
	return c:IsRace(RACE_DRAGON,fc,sumtype,tp) and c:IsType(TYPE_FUSION,fc,sumtype,tp)
end
function s.fusfilter2(c,fc,sumtype,tp)
	return c:IsRace(RACE_DRAGON,fc,sumtype,tp) and c:IsType(TYPE_SYNCHRO,fc,sumtype,tp)
end
function s.fusfilter3(c,fc,sumtype,tp)
	return c:IsRace(RACE_DRAGON,fc,sumtype,tp) and c:IsType(TYPE_XYZ,fc,sumtype,tp)
end
function s.fusfilter4(c,fc,sumtype,tp)
	return c:IsRace(RACE_DRAGON,fc,sumtype,tp) and c:IsType(TYPE_PENDULUM,fc,sumtype,tp)
end

function s.splimit(e, se, sp, st)
	return se:GetHandler():IsCode(48)
end

function s.limval(e,re,rp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER)
		and rc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end

function s.sppfilter(c)
	return c:IsFaceup() and c:IsReleasable() and c:IsSetCard(0xf8)
end
function s.sppcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and e:GetHandler():IsFaceup()
		and Duel.IsExistingMatchingCard(s.sppfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function s.sppop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.sppfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end

function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e3,true)
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

--Immune
function s.efilter(e,te)
	--local tc=te:GetHandler()
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() 
	and (te:IsActiveType(TYPE_XYZ+TYPE_FUSION+TYPE_SYNCHRO) and te:IsActiveType(TYPE_MONSTER))
end

function s.refilter(e,te)
	return not (te:GetOwner():IsCode(57) and te:GetOwnerPlayer()==e:GetOwnerPlayer())
end

function s.ndcfilter(c)
	return c:IsFaceup() 
	and (c:IsType(TYPE_XYZ) or c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO)) and c:IsType(TYPE_MONSTER)
end

function s.indfilter(c,tpe)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(tpe) and c:IsType(TYPE_MONSTER)
end
function s.indcon(e)
	return Duel.IsExistingMatchingCard(s.indfilter,0,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
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
function s.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),tp,LOCATION_HAND)
end
function s.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.Destroy(g,REASON_EFFECT)
end

function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
	and not c:IsOriginalCode(442) and not c:IsOriginalCode(446)
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
